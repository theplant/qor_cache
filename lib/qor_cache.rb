require "qor_cache/configuration"
require "qor_cache/active_record"
require "qor_cache/railtie"
require "qor_cache/kernel"
require "digest/md5"

module Qor
  module Cache
    class Base
      def self.cache_store
        @cache_store || Rails.cache
      end

      def self.init_cache_methods
        Qor::Cache::Configuration.find(:scope).map do |m|
          model = m.name.to_s.classify.constantize

          m.find(:cache_method).map do |node|
            method = node.name
            original_method = "_uncached_#{method}_for_qor_cache".to_sym

            model.class_eval do
              alias_method original_method, method

              define_method(method) do |*args|
                _cache_key = Digest::MD5.hexdigest([
                  method,
                  node.data.map {|x| qor_cache_key(x) },
                  cache_key,
                  args.map(&:inspect).join("-")
                ].map(&:to_s).join("-"))

                Qor::Cache::Base.cache_store.fetch(_cache_key) do
                  self.send(original_method, *args)
                end
              end
            end
          end
        end
      end

      def self.init_cache_class_methods
        Qor::Cache::Configuration.find(:scope).map do |m|
          model = m.name.to_s.classify.constantize
          m.find(:cache_class_method).map do |node|
            method = node.name
            original_method = "_uncached_#{method}_for_qor_cache".to_sym

            model.instance_eval <<-EOS, __FILE__, __LINE__ + 1
              class << self
                alias :#{original_method} :#{method}
              end

              def self.#{method}(*args)
                _cache_key = Digest::MD5.hexdigest([
                  :#{method},
                  #{node.data}.map {|x| qor_cache_key(x) },
                  cache_key,
                  args.map(&:inspect).join("-")
                ].map(&:to_s).join("-"))

                Qor::Cache::Base.cache_store.fetch(_cache_key) do
                  self.send(:#{original_method}, *args)
                end
              end
            EOS
          end
        end
      end
    end
  end
end
