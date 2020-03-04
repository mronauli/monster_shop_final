require 'rails_helper'

RSpec.describe "on a merchant's discount show page" do
  context "as a merchant employee" do
    before(:each) do
      @bike_shop = Merchant.create(
        name: "Brian's Bike Shop",
        address: '123 Bike Rd.',
        city: 'Richmond',
        state: 'VA',
        zip: 11234)

      @merchant_user = User.create(
        name: "Maria R",
        address: "321 Notmain Rd.",
        city: "Broomfield",
        state: "CO",
        zip: "80020",
        email: "mariaaa@example.com",
        password: "supersecure1",
        role: 1,
        merchant: @bike_shop)

      @dog_shop = Merchant.create(
        name: "Brian's Dog Shop",
        address: '125 Doggo St.',
        city: 'Denver',
        state: 'CO',
        zip: 80210)

      @discount_1 = Discount.create(name: "Black Friday", percentage: 0.2, bulk: 20, merchant: @bike_shop)
      @discount_2 = Discount.create(name: "10% Off", percentage: 0.1, bulk: 10, merchant: @bike_shop)
      @discount_3 = Discount.create(name: "Winter Sale", percentage: 0.25, bulk: 50, merchant: @bike_shop)
      @discount_4 = Discount.create(name: "Better than BOGO", percentage: 0.50, bulk: 100, merchant: @dog_shop)
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 500)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 50)
      @pump = @bike_shop.items.create(name: "Pump", description: "for filling flat tires", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 95)
    end
    it "can see the name of a discount" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
      visit "/merchant/discounts/#{@discount_1.id}"
      expect(page).to have_content(@discount_1.name)
      expect(page).to_not have_content(@discount_4.name)
    end
    it "can see a button to deactivate the discount" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

      visit "/merchant/discounts/#{@discount_1.id}"
      expect(page).to have_button("Delete Discount")
    end
  end
end
