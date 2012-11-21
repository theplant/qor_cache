module Qor
  module Cache
    module ActiveRecord
      def self.included(base)
        base.extend SingletonMethods
        base.send :include, InstanceMethods
        base.after_save :_qor_cache_expire
        base.after_destroy :_qor_cache_expire
      end
    end

    module SingletonMethods
      def _qor_cache_key
        "#{self.name}-cache_key"
      end

      def cache_key
        Qor::Cache::Base.cache_store.fetch(_qor_cache_key) do
          key = self.name.to_s
          key << Time.now.to_i.to_s
          key << rand.to_s
          Digest::SHA1.hexdigest(key)
        end
      end

      def _qor_cache_expire
        Qor::Cache::Base.cache_store.delete(_qor_cache_key)
        true
      end
    end

    module InstanceMethods
      def _qor_cache_expire
        self.class._qor_cache_expire
      end
    end
  end
end
