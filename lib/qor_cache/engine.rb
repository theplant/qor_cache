module Qor
  module Cache
    class Railtie < Rails::Engine

      initializer "qor_cache_init" do
        ActiveSupport.on_load(:active_record) do
          ::ActiveRecord::Base.send :include, ::Qor::Cache::ActiveRecord
        end

        ActiveSupport.on_load(:after_initialize) do
          Qor::Cache::Base.init_cache_methods
          Qor::Cache::Base.init_cache_class_methods
        end
      end
    end
  end
end
