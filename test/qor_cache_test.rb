require 'test_helper'
require 'timeout'

class QorCacheTest < ActiveSupport::TestCase
  test "cache instance method" do
    product = FactoryGirl.create(:product)
    result1 = product.slow_method
    result2 = product.slow_method
    assert_equal result1, result2
  end
end
