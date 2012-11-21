Qor Cache
=========

## Usage

    # config/qor/cache.rb
    cache_key "product" do
      [Product, Collection]
    end

    cache_key "current_season" do
      Season.current
    end

    scope :color_variation do
      cache_method :heavy_method_related_to_products, 'product'
      cache_method :heavy_method_related_to_product do |s|
        s.product
      end

      cache_class_method :heavy_class_method
      cache_class_method :heavy_class_method_related_to_current_season, 'current_season'

      cache_field :product_code, :from => [:product, :code]
    end


    # app/models/color_variation.rb
    def heavy_method_related_to_products
      Product.all.map(&:id).sum
    end

    def heavy_method_related_to_product
      product.size_variations.map(&:id).sum
    end

    def self.heavy_class_method
      self.all.map {|x| x.id}.sum
    end

    def self.heavy_class_method_related_to_current_season
      where(:season_id => Season.current.id).map {|x| x.id}.sum
    end

    # app/views/xxx.html.erb
    cache qor_cache_key('product', 'current_season') do
      xxxxx
    end

    cache qor_cache_key('product') { current_user.role } do
      xxxxx
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
