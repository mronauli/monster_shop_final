require 'rails_helper'

describe Discount, type: :model do

  describe "relationships" do
    it {should belong_to :merchant}
  end

  describe "validationss" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :percentage}
    it {should validate_presence_of :bulk}
  end

end
