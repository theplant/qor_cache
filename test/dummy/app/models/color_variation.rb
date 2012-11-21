class ColorVariation < ActiveRecord::Base
  attr_accessible :code, :name, :product_code
  belongs_to :product

  def slow_method
    Product.order("updated_at").first.updated_at
  end

  def slow_method_with_product
    product.updated_at
  end

  def self.slow_class_method
    "#{Product.order("updated_at").first.updated_at}#{rand}"
  end
end
