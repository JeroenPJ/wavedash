class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_order
  # before_action :redirect_to_root

  private

  def redirect_to_root
    redirect_to root_path
  end

  def set_order
    begin
      @order = Order.find(session[:order_id])
    rescue ActiveRecord::RecordNotFound
      # create a new order
      @order = Order.create
      session[:order_id] = @order.id
    end
  end
end
