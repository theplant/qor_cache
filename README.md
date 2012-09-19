Qor Cache
=========

SAMPLE:

  config/qor/cache.rb

    enabled_environments ['production']

    cache_key "product" do
      [Product, Collection]
    end

    cache_key "current_season" do
      [Season.current]
    end

    scope :size_variation do
      cache_class_method :aaa
      cache_method :bbb, 'product'
      cache_field :product_code, :from => [:color_variation, :product, :code]
    end


  app/models/xxx.rb

     cache_class_method :aaa
     cache_method :bbb, 'product'
     cache_field :product_code, :from => [:color_variation, :product, :code]

     def self.aaa
     end

     def bbb
     end

  app/views/xxx.html.erb

    cache qor_cache_key('product', 'current_season') do
      xxxxx
    end
