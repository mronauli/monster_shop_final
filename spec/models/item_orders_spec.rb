require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'instance methods' do
    before(:each) do
      @default_user_1 = User.create({
        name: "Paul D",
        address: "123 Main St.",
        city: "Broomfield",
        state: "CO",
        zip: "80020",
        email: "pauld@example.com",
        password: "supersecure1",
        role: 0
        })
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @discount_1 = Discount.create(name: "Black Friday", percentage: 0.2, bulk: 20, merchant: @meg)
      @discount_2 = Discount.create(name: "10% Off", percentage: 0.1, bulk: 10, merchant: @meg)
      @discount_3 = Discount.create(name: "Winter Sale", percentage: 0.1, bulk: 10, merchant: @bike_shop)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 500)
      @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 50)
      @pump = @bike_shop.items.create(name: "Pump", description: "for filling flat tires", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 95)
      @order_1 = @default_user_1.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @order_1 = @default_user_1.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @item_order_1 = @order_1.item_orders.create(item: @tire, price: @tire.price, quantity: 2)
      @item_order_2 = @order_1.item_orders.create(item: @chain, price: @chain.price, quantity: 11)
    end
    it 'subtotal' do
      expect(@item_order_1.subtotal).to eq(200)
      expect(@item_order_2.subtotal).to eq(495.0)
    end
    it 'item_order_discount' do
      expect(@item_order_1.item_order_discount).to eq(nil)
      expect(@item_order_2.item_order_discount).to eq(@discount_2)
    end
    
  end

end
