class UserOrdersController < ApplicationController

  def index
    if current_user && current_user.default_user? || current_user.merchant_user?
      @orders = current_user.orders
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    order = Order.find(params[:id])
    order.cancel
    flash[:notice] = "Your Order has been Cancelled. :("
    redirect_to '/profile'
  end
end
