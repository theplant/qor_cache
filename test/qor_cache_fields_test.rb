require 'test_helper'
require 'timeout'

class QorCacheFieldsTest < ActiveSupport::TestCase
  test "cache field should works" do
    product = FactoryGirl.create(:product, :code => '1111')
    product.color_variations << FactoryGirl.build(:color_variation)
    product.save

    color_variation = product.color_variations.first

    assert_equal color_variation.product_code, '1111'
  end

  test "cached field should be updated after update" do
    product = FactoryGirl.create(:product, :code => '1111')
    product.color_variations << FactoryGirl.build(:color_variation)
    product.save

    color_variation = product.color_variations.first
    assert_equal color_variation.product_code, '1111'

    product.update_attribute(:code, '2222')
    assert_equal color_variation.reload.product_code, '2222'

    product.update_attribute(:code, '3333')
    assert_equal color_variation.reload.product_code, '3333'
  end
end
