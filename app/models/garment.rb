class Garment < ApplicationRecord
  belongs_to :category

  belongs_to :artist, optional: true

  has_many :order_items
  has_many :orders, through: :order_items

  has_one_attached :thumbnail
  has_many_attached :images

  validates :name, :description, :euros, :cents, :category_id, presence: true
  validates :name, uniqueness: true

  def price
    self.euros + (self.cents / 100.0)
  end

  def slug
    self.name.parameterize
  end

  def to_param
    slug
  end

  def release_date
    self.created_at.strftime('%Y %m %d')
  end

  def self.find_by_slug(slug)
    self.find_by(name: slug.gsub(/-/, ' '))
  end

  def thumbnail_path
    thumbnail.attached? ? thumbnail : "wavedash.png"
  end
end
