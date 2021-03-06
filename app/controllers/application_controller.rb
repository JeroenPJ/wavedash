class ApplicationController < ActionController::Base
  include ControllerHelper

  protect_from_forgery with: :exception
  before_action :set_order
  # before_action :redirect_to_root

  def raise_not_found
    raise ActionController::RoutingError.new('not found')
  end

  private

  def redirect_to_root
    redirect_to root_path unless logged_in?
  end

  def set_order
    @order = Order.set_order(session[:order_id])
    session[:order_id] = @order.id unless @order.id == session[:order_id]
  end
end
