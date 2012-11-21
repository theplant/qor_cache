class Product < ActiveRecord::Base
  attr_accessible :code, :name

  def slow_method
    Time.now.to_i + rand()
  end
end
