require "rails_helper"

RSpec.describe Cart do
  before(:each) do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @discount_1 = Discount.create(name: "Black Friday", percentage: 0.2, bulk: 20, merchant: @meg)
    @discount_2 = Discount.create(name: "10% Off", percentage: 0.1, bulk: 10, merchant: @meg)
    @discount_3 = Discount.create(name: "Winter Sale", percentage: 0.1, bulk: 10, merchant: @bike_shop)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 500)
    @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 50)
    @pump = @bike_shop.items.create(name: "Pump", description: "for filling flat tires", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 95)
    @items = [@tire, @chain, @pump]
    @contents = Hash.new(0)
    @contents[@tire.id.to_s] = 20
    @contents[@chain.id.to_s] = 34
    @contents[@pump.id.to_s] = 9
    @cart = Cart.new(@contents)
  end

  it '#total_discount' do
    expect(@cart.total_discount).to eq(740.0)
  end

  it '#checkout' do
    expect(@cart.checkout).to eq(3185.0)
  end

  it '#item_discount' do
    expect(@cart.item_discount(@pump)).to eq(0)
    expect(@cart.item_discount(@tire)).to eq(400)
  end

  it '#subtotal' do
    expect(@cart.subtotal(@pump)).to eq(225)
    expect(@cart.subtotal(@tire)).to eq(1600)
  end

  it '#item_quantity' do
    expect(@cart.item_quantity(@pump.id.to_s)).to eq(9)
  end
end
