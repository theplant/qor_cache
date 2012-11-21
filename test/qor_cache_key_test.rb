require 'test_helper'

class QorCacheKeyTest < ActiveSupport::TestCase
  test "qor_cache_key with one key" do
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

  test "qor_cache_key with many keys" do
    cache_key1 = qor_cache_key(:product, :color_variation)
    cache_key2 = qor_cache_key(:product, :color_variation)
    assert_equal cache_key1, cache_key2

    product = FactoryGirl.create(:product)

    cache_key3 = qor_cache_key(:product, :color_variation)
    assert_not_equal cache_key1, cache_key3
  end

  test "qor_cache_key with block" do
    def same_value
      "same_value"
    end
    same_1 = qor_cache_key(:product) do
      same_value
    end

    same_2 = qor_cache_key(:product) do
      same_value
    end

    assert_equal same_1, same_2

    def random_value
      rand()
    end
    random_1 = qor_cache_key(:product) do
      random_value
    end

    random_2 = qor_cache_key(:product) do
      random_value
    end

    assert_not_equal random_1, random_2
  end
end
