require 'factory_girl'

FactoryGirl.define do
  factory :product do
    code 'A1111'
    name 'Product A1111'
  end

  factory :color_variation do
    code 'C1111'
    name 'ColorVariation A1111'
  end
end
