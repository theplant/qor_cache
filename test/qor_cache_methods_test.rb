require 'test_helper'
require 'timeout'

class QorCacheMethodsTest < ActiveSupport::TestCase
  test "instance method should be cached" do
    product = FactoryGirl.create(:product)

    %w(slow_method slow_method1).map do |method|
      result1 = product.send(method)
      result2 = product.send(method)
      result3 = product.send("_uncached_#{method}_for_qor_cache".to_sym)
      assert_equal result1, result2
      assert_not_equal result1, result3
    end
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

  test "class method should be cached" do
    %w(slow_class_method slow_class_method1).map do |method|
      result1 = Product.send(method)
      result2 = Product.send(method)
      result3 = Product.send("_uncached_#{method}_for_qor_cache".to_sym)
      assert_equal result1, result2
      assert_not_equal result1, result3
    end
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
end
