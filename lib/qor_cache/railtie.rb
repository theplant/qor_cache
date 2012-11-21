module Qor
  module Cache
    class Railtie < Rails::Railtie

      initializer "qor_cache_init_cache_method" do
        Qor::Cache::Configuration.find(:scope).map do |m|
          model = m.name.to_s.classify.constantize

          [[:cache_method, :class_eval], [:cache_class_method, :instance_eval]].map do |child_key, model_method|
            m.find(child_key).map do |node|
              method = node.name

              model.send(model_method) do
                original_method_name = "_uncached_#{method}_for_qor_cache".to_sym

                alias_method original_method_name, method
                define_method(method) do |*args|
                  cache_key = method

                  Qor::Cache::Base.cache_store.fetch(cache_key) do
                    self.send(original_method_name, *args)
                  end
                end
              end
            end
          end
        end
      end

    end
  end
end
