class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :garments, through: :order_items

  has_one :address, dependent: :destroy

  belongs_to :status

  scope :paid, -> { where.not(paid_at: nil) }

  validates :status, presence: true

  before_validation :set_status, on: :create

  def add(garment, size, quantity = 1)
    return false, nil if status == "paid"

    if order_items.exists?(garment: garment, size: size)
      item = order_items.find_by(garment: garment, size: size)
      persisted = item.increase!(quantity)
    else
      item = order_items.create(garment: garment, size: size, quantity: quantity)
      persisted = item.persisted?
    end

    return persisted, item.quantity
  end

  def quantity
    order_items.map(&:quantity).sum
  end

  def subtotal
    order_items.map(&:subtotal).sum
  end

  def stripe_amount
    # stripe wants amount in cents in integer
    (subtotal * 100).to_i
    return 100 # for testing
  end

  def empty?
    order_items.empty?
  end

  def valid_address?
    !address.nil?
  end

  def paid?
    !paid_at.nil?
  end

  def mark_as_paid!
    self.paid_at = DateTime.now
    self.status = Status.find_by_text("paid")
    save
  end

  def self.set_order(id)
    if exists?(id)
      order = find(id)
      return order unless order.paid?
    end

    return self.new
  end

  # statistical methods

  def self.units_sold
    all.paid.includes(:order_items).group(:garment_id).sum(:quantity).except(nil)
  end

  # obfuscated id using multiplicative inverse
  # https://ericlippert.com/2013/11/14/a-practical-use-of-multiplicative-inverses/

  def obfuscated_id
    id * ENV['OBFUSCATOR'].to_i % 1000000
  end

  def self.deobfuscate_id(id)
    id * ENV['OBFUSCATOR_MI'].to_i % 1000000
  end

  private

  def set_status
    self.status = Status.find_by_text("browsing")
  end
end
