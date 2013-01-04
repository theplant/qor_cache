cache_key :product do
  Product
end

cache_key :color_variation do
  [ColorVariation]
end

cache_key :product_and_color_variation do
  [Product, ColorVariation]
end

scope :product do
  cache_method :slow_method
  cache_method :slow_method_with_args

  cache_class_method :slow_class_method
  cache_class_method :slow_class_method_with_args
end

scope :color_variation do
  cache_method :slow_method, 'product'

  cache_method :slow_method_with_product do |s|
    s.product
  end

  cache_class_method :slow_class_method, 'product'

  cache_field :product_code, :from => [:product, :code]
end

cache_includes "nocache_time", :no_cache => true
