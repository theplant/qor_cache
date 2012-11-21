module Qor
  module Cache
    class Railtie < Rails::Railtie

      initializer "insert_active_record_methods_for_qor_cache" do
        ActiveSupport.on_load(:active_record) do
          ::ActiveRecord::Base.send :include, ::Qor::Cache::ActiveRecord
        end
      end

      initializer "qor_cache_init_cache_method", :after => "insert_active_record_methods_for_qor_cache" do
        Qor::Cache::Base.init_cache_methods
        Qor::Cache::Base.init_cache_class_methods
      end
    end
  end
end
