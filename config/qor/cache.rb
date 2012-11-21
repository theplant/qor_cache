scope :product do
  cache_method :slow_method
  cache_method :slow_method1

  cache_class_method :slow_class_method
  cache_class_method :slow_class_method1
end
