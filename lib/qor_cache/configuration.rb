require 'qor_dsl'

module Qor
  module Cache
    class Configuration
      include Qor::Dsl

      default_configs ["config/qor/cache.rb"]

      node :cache_includes
      node :cache_key

      node :scope do
        node :cache_class_method
        node :cache_method
        node :cache_field
      end
    end
  end
end
