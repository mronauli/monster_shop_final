class Discount < ApplicationRecord
  validates_presence_of :name, :percentage, :bulk
  belongs_to :merchant
end
