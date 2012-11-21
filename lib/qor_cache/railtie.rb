module Qor
  module Cache
    class Railtie < Rails::Railtie

      initializer "insert_active_record_methods_for_qor_cache" do
        ActiveSupport.on_load(:active_record) do
          ::ActiveRecord::Base.send :include, ::Qor::Cache::ActiveRecord
        end
      end

      initializer "qor_cache_init_cache_method", :after => "insert_active_record_methods_for_qor_cache" do
        Qor::Cache::Configuration.find(:scope).map do |m|
          model = m.name.to_s.classify.constantize

          m.find(:cache_method).map do |node|
            method = node.name
            original_method = "_uncached_#{method}_for_qor_cache".to_sym

            model.class_eval do
              alias_method original_method, method

              define_method(method) do |*args|
                _cache_key = [method, cache_key].map(&:to_s).join("-")

                Qor::Cache::Base.cache_store.fetch(_cache_key) do
                  self.send(original_method, *args)
                end
              end
            end
          end

          m.find(:cache_class_method).map do |node|
            method = node.name
            original_method = "_uncached_#{method}_for_qor_cache".to_sym

            model.instance_eval <<-EOS, __FILE__, __LINE__ + 1
              class << self
                alias :#{original_method} :#{method}
              end

              def self.#{method}(*args)
                _cache_key = [:#{method}, cache_key].map(&:to_s).join("-")

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
