module Qor
  module CacheHelper
    def qor_cache_includes(filename)
      env = respond_to?(:request) && request.respond_to?(:env) ? request.env : {}
      path = URI.parse(filename).path rescue filename
      node = Qor::Cache::Configuration.deep_find(:cache_includes, path)[0]

      cache_key = node.nil? ? "" : qor_cache_key(*node.data.select {|x| x.is_a? String }, &node.block)
      key = "/qor_cache_includes/#{filename}?#{cache_key}"

      if env['QOR_CACHE_SSI_ENABLED']
        %Q[<!--# include virtual="#{key}" -->]
      elsif env['QOR_CACHE_ESI_ENABLED']
        %Q[<esi:include src="#{key}"/>]
      else
        render_qor_cache_includes(path, key)
      end.html_safe
    end

    def render_qor_cache_includes(path, cache_key)
      options = Qor::Cache::Configuration.first(path).try(:option) || {}

      format = params["format"] || "html" rescue "html"
      file = Dir[File.join(Rails.root, "app/views/qor_cache_includes", "#{path}.#{format}*")][0]

      if options.delete(:no_cache) == true
        Erubis::Eruby.new(File.read(file)).result(binding)
      else
        Rails.cache.fetch(cache_key, options) { Erubis::Eruby.new(File.read(file)).result(binding) }
      end
    end
  end
end
