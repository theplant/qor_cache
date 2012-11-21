require 'test_helper'

class QorCacheKeyTest < ActiveSupport::TestCase
  test "qor_cache_key should be cached, expired correctly" do
    cache_key1 = qor_cache_key(:product)
    cache_key2 = qor_cache_key(:product)
    assert_equal cache_key1, cache_key2

    cache_key_pc1 = qor_cache_key(:product_and_color_variation)
    cache_key_pc2 = qor_cache_key(:product_and_color_variation)
    assert_equal cache_key_pc1, cache_key_pc2

    product = FactoryGirl.create(:product)

    cache_key3 = qor_cache_key(:product)
    assert_not_equal cache_key1, cache_key3

    cache_key_pc3 = qor_cache_key(:product_and_color_variation)
    assert_not_equal cache_key_pc1, cache_key_pc3

    product.destroy
    assert_not_equal cache_key3, qor_cache_key(:product)
    assert_not_equal cache_key_pc3, qor_cache_key(:product_and_color_variation)
  end
end
