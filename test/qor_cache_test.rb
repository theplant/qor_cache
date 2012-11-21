require 'test_helper'
require 'timeout'

class QorCacheTest < ActiveSupport::TestCase
  test "instance method should be cached" do
    product = FactoryGirl.create(:product)

    method = "slow_method"
    result1 = product.send(method)
    result2 = product.send(method)
    result3 = product.send("_uncached_#{method}_for_qor_cache".to_sym)
    assert_equal result1, result2
    assert_not_equal result1, result3
  end
end
