scope :product do
  cache_method :slow_method
  cache_method :slow_method1

  cache_class_method :slow_class_method
  cache_class_method :slow_class_method1
end

scope :color_variation do
  cache_field :product_code, :from => [:product, :code]
end
