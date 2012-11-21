require "qor_cache/configuration"
require "qor_cache/active_record"
require "qor_cache/railtie"

module Qor
  module Cache
    class Base
      def self.cache_store
        @cache_store || Rails.cache
      end
    end
  end
end
