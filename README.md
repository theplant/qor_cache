Qor Cache
=========

Usage:

    # config/qor/cache.rb
    cache_key "product" do
      [Product, Collection]
    end

    cache_key "current_season" do
      Season.current
    end

    scope :color_variation do
      cache_method :heavy_method_related_to_product do |s|
        s.product
      end

      cache_class_method :heavy_method
      cache_class_method :heavy_method_related_to_current_season, 'current_season'

      cache_field :product_code, :from => [:product, :code]
    end


     # app/models/color_variation.rb
     def self.heavy_method
       self.all.map {|x| x.id}.sum
     end

     def self.heavy_method_related_to_current_season
       where(:season_id => Season.current.id).map {|x| x.id}.sum
     end

     def heavy_method_related_to_product
       product.size_variations.map(&:id).sum
     end

  app/views/xxx.html.erb

    cache qor_cache_key('product', 'current_season') do
      xxxxx
    end
