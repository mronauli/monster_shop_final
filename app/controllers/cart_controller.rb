class CartController < ApplicationController
before_action :no_admin
  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    @items = cart.items_and_quantities
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def increment_decrement
    if params[:increment_decrement] == "increment"
      cart.add_quantity(params[:item_id]) unless cart.limit_reached?(params[:item_id])
    elsif params[:increment_decrement] == "decrement"
      cart.subtract_quantity(params[:item_id])
      return remove_item if cart.quantity_zero?(params[:item_id])
    end
    flash[:success] = "Item qualifies for a bulk discount!" if item_qualifies_for_discount?
    redirect_to '/cart'
  end

  def no_admin
    render file: "/public/404" if !current_user.nil? && current_user.admin_user?
  end

  private
  def item_qualifies_for_discount?
    item = Item.find(params[:item_id])
    item.any_discounts?(cart.item_quantity(params[:item_id]))
  end
end
