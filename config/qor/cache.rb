scope :product do
  cache_method :slow_method
end
