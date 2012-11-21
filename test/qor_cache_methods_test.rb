require 'test_helper'
require 'timeout'

class QorCacheMethodsTest < ActiveSupport::TestCase
  test "instance method should be cached" do
    product = FactoryGirl.create(:product)
    method = 'slow_method'

    result1 = product.send(method)
    result2 = product.send(method)
    result3 = product.send("_uncached_#{method}_for_qor_cache".to_sym)
    assert_equal result1, result2
    assert_not_equal result1, result3
  end

  test "instance method should be updated after update" do
    product = FactoryGirl.create(:product)
    method = "slow_method"

    result1 = product.send(method)
    result2 = product.send(method)
    product.update_attribute(:updated_at, 1.minute.since)
    result3 = product.send(method)
    assert_equal result1, result2
    assert_not_equal result1, result3
  end

  test "instance method with argument" do
    product = FactoryGirl.create(:product)
    method = 'slow_method_with_args'

    result1 = product.send(method, 1)
    result2 = product.send(method, 1)
    result3 = product.send(method, 2)
    result4 = product.send(method, 2)
    assert_equal result1, result2
    assert_not_equal result1, result3
    assert_equal result3, result4

    result5 = product.send(method, Product.all)
    result6 = product.send(method, Product.all)
    assert_equal result5, result6
    assert_not_equal result1, result6
  end

  test "class method should be cached" do
    method = 'slow_class_method'
    result1 = Product.send(method)
    result2 = Product.send(method)
    result3 = Product.send("_uncached_#{method}_for_qor_cache".to_sym)
    assert_equal result1, result2
    assert_not_equal result1, result3
  end

  test "class method should be updated after update" do
    product = FactoryGirl.create(:product)
    method = "slow_class_method"

    result1 = Product.send(method)
    result2 = Product.send(method)
    product.update_attribute(:updated_at, 1.minute.since)
    result3 = Product.send(method)
    assert_equal result1, result2
    assert_not_equal result1, result3
  end

  test "class method should be updated after destroy" do
    product = FactoryGirl.create(:product)
    method = "slow_class_method"

    result1 = Product.send(method)
    result2 = Product.send(method)
    product.destroy
    result3 = Product.send(method)
    assert_equal result1, result2
    assert_not_equal result1, result3
  end

  test "class method with argument" do
    product = FactoryGirl.create(:product)
    method = 'slow_class_method_with_args'

    result1 = Product.send(method, 1)
    result2 = Product.send(method, 1)
    result3 = Product.send(method, 2)
    result4 = Product.send(method, 2)
    assert_equal result1, result2
    assert_not_equal result1, result3
    assert_equal result3, result4

    result5 = Product.send(method, Product.all)
    result6 = Product.send(method, Product.all)
    assert_equal result5, result6
    assert_not_equal result1, result6
  end
end
