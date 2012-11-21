module Qor
  module Cache
    module ActiveRecord
      def self.included(base)
        base.extend SingletonMethods
        base.send :include, InstanceMethods
        base.after_save :_qor_cache_expire
        base.after_destroy :_qor_cache_expire

        base.before_create :_qor_cache_sync_cached_fields
        base.after_save :_qor_cache_sync_qor_cache_fields
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

      def _qor_cache_sync_cached_fields
        nodes = Qor::Cache::Configuration.deep_find(:cache_field) do |node|
          node.parent.is_node?(:scope, self.class.name.demodulize.underscore)
        end

        nodes.map do |node|
          obj = node.options[:from].inject(self) { |obj, value| obj.send(value) }
          self.send("#{node.name}=", obj)
        end
      end

      def _qor_cache_sync_qor_cache_fields
        nodes = Qor::Cache::Configuration.deep_find(:cache_field) do |node|
          node.options[:from][-2].to_sym == self.class.name.demodulize.underscore.to_sym
        end

        nodes.map do |node|
          node_model = node.parent.name.to_s.classify.constantize
          fk = self.class.reflections.select {|name, ref| ref.klass == node_model}.first.last.foreign_key

          node_method = node.options[:from][-1]
          updates = {node.name => send(node_method)}

          node_model.update_all(updates, ["#{fk} = ?", self.id]) if updates.present?
        end
      end
    end
  end
end
