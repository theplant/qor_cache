class ColorVariation < ActiveRecord::Base
  attr_accessible :code, :name, :product_code
  belongs_to :product
end
