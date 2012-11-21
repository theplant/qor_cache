class Product < ActiveRecord::Base
  attr_accessible :code, :name
  has_many :color_variations

  def slow_method
    Time.now.to_i + rand()
  end

  def slow_method_with_args(argu)
    Time.now.to_i + rand()
  end

  def self.slow_class_method
    Time.now.to_i + rand()
  end

  def self.slow_class_method_with_args(argu)
    Time.now.to_i + rand()
  end
end
