class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items_and_quantities
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    if item_discount(item).nil?
      item.price * @contents[item.id.to_s]
    else
      item.price * @contents[item.id.to_s] - item_discount(item)
    end
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

  def add_quantity(item)
    @contents[item] += 1
  end

  def subtract_quantity(item)
    @contents[item] -= 1
  end

  def limit_reached?(item)
    return @contents[item] if @contents[item] == (Item.find(item).inventory)
  end

  def quantity_zero?(item)
    return true if @contents[item] == 0
  end

  def item_quantity(item_id)
    @contents[item_id] || 0
  end

  def item_discount(item)
    quantity = @contents[item.id.to_s]
    eligible_discount = item.any_discounts?(quantity)
    if eligible_discount.nil?
      0
    else
      item.price * quantity * eligible_discount.percentage
    end
  end

  def total_discount
    discount_amount = Hash.new(0)
    items_and_quantities.each do |item, quantity|
      eligible_discount = item.any_discounts?(quantity)
      if !eligible_discount.blank?
        discount_amount[item] += item.price * quantity * eligible_discount.percentage
      else
        discount_amount[item] += 0
      end
    end
    discount_amount.values.sum
  end

  def checkout
    total - total_discount
  end
end
