module Qor
  module Cache
    module ActiveRecord
      extend ActiveSupport::Concern

      included do
        after_save :_qor_cache_expire
        after_destroy :_qor_cache_expire

        before_create :_qor_cache_cache_from_external
        after_save :_qor_cache_cache_to_external
      end

      # after_save: expire caches
      def _qor_cache_expire
        self.class._qor_cache_expire
      end

      # before_create: cache value from external
      def _qor_cache_cache_from_external
        nodes = Qor::Cache::Configuration.deep_find(:cache_field) do |node|
          node.parent.is_node?(:scope, self.class.name.demodulize.underscore)
        end

        nodes.map do |node|
          value = node.options[:from].inject(self) { |obj, value| obj = obj.try(value) }
          self.send("#{node.name}=", value)
        end
      end

      # after_save: cache value to external
      def _qor_cache_cache_to_external
        nodes = Qor::Cache::Configuration.deep_find(:cache_field) do |node|
          node.options[:from][-2].to_sym == self.class.name.demodulize.underscore.to_sym
        end

        nodes.map do |node|
          node_model = node.parent.name.to_s.classify.constantize
          fk = self.class.reflections.select {|name, ref| ref.klass == node_model}.first.last.foreign_key

          node_method = node.options[:from][-1]
          update_attrs = {node.name => try(node_method)}

          node_model.update_all(update_attrs, ["#{fk} = ?", self.id]) if update_attrs.present?
        end
      end

      module ClassMethods
        def _qor_cache_key
          "#{self.name}-cache_key"
        end

        def cache_key
          Qor::Cache::Base.cache_store.fetch(_qor_cache_key) do
            rand_value = self.name.to_s + rand.to_s
            Digest::SHA1.hexdigest(rand_value)
          end
        end

        def _qor_cache_expire
          Qor::Cache::Base.cache_store.delete(_qor_cache_key)
          true
        end
      end
    end
  end
end
