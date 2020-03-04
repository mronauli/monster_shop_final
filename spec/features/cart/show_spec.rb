require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @default_user = User.create({
          name: "Paul D",
          address: "123 Main St.",
          city: "Broomfield",
          state: "CO",
          zip: "80020",
          email: "pauld@gmail.com",
          password: "supersecure1",
          role: 0
          })
        @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @discount_1 = Discount.create(name: "Black Friday", percentage: 0.2, bulk: 20, merchant: @mike)
        @discount_2 = Discount.create(name: "10% Off", percentage: 0.1, bulk: 10, merchant: @mike)
        @discount_3 = Discount.create(name: "Winter Sale", percentage: 0.25, bulk: 50, merchant: @meg)
        @discount_4 = Discount.create(name: "Better than BOGO", percentage: 0.50, bulk: 100, merchant: @meg)
        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 55)
        @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 70)
        @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper,@tire,@pencil]
      end

      it "I must be registered or logged in to checkout" do
        visit '/cart'

        expect(page).to have_content("You must register or be logged in to checkout.")
        expect(page).to have_link("Register")
        expect(page).to have_link("Login")
        expect(page).not_to have_link("Checkout")
      end

      it 'I can empty my cart by clicking a link' do
        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"
        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it 'I see all items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("$#{item.price}")
            expect(page).to have_content("1")
            expect(page).to have_content("$#{item.price}")
          end
        end
        expect(page).to have_content("Total: $122")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'
        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$4")
        end

        expect(page).to have_content("Total: $124")
      end

      it "allows me to increment the items in my cart" do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@default_user)

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          click_on ("+")
          expect(page).to have_content("3")
          21.times do
            click_on ("+")
          end
          expect(current_path).to eq('/cart')
          expect(page).to have_content("24")

          end
          click_link "Checkout"
          fill_in :name, with: @default_user[:name]
          fill_in :address, with: @default_user[:address]
          fill_in :city, with: @default_user[:city]
          fill_in :state, with: @default_user[:state]
          fill_in :zip, with: @default_user[:zip]
          click_button "Create Order"
        end

      it "doesn't allow me to increment the items in my cart past inventory limit" do
        tire = @meg.items.create(
          name: "Gatorskins",
          description: "They'll never pop!",
          price: 100,
          image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588",
          inventory: 3
        )

        visit "/items/#{tire.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{tire.id}" do
          expect(page).to have_content("1")
          click_on ("+")
          expect(page).to have_content("2")
          click_on ("+")
          expect(page).to have_content("3")
          click_on ("+")
          expect(page).to have_content("3")
        end
      end


      it "allows me to decrement the items in my cart" do

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          click_on ("+")
          expect(page).to have_content("3")
          click_on ("-")
          expect(page).to have_content("2")
        end
      end

      it "doesn't allow me to increment the items in my cart past inventory limit" do
        frog = @meg.items.create(
          name: "Frog",
          description: "It's a Frog!",
          price: 100,
          image: "https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-1200-80.jpg",
          inventory: 3
        )

        visit "/items/#{frog.id}"

        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{frog.id}" do
          expect(page).to have_content("1")
          click_on ("+")
          expect(page).to have_content("2")
          click_on ("-")
          expect(page).to have_content("1")
          click_on ("-")
        end

        expect(page).not_to have_content(frog.name)
      end
    end
  end

  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      it "I see a message saying my cart is empty" do
        visit '/cart'
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do NOT see the link to empty my cart" do
        visit '/cart'
        expect(page).to_not have_link("Empty Cart")
      end
    end
  end
end
