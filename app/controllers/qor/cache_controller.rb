module Qor
  class CacheController < ActionController::Base
    def includes
      fullpath = request.fullpath
      path = params[:path]

      result_block = proc do
        format = params["format"] || "html"
        file = Dir[File.join(Rails.root, "app/views/qor_cache_includes", "#{path}.#{format}*")][0]
        Erubis::Eruby.new(File.read(file)).result(binding)
      end

      options = Qor::Cache::Configuration.first(path).try(:option) || {}

      result = options.delete(:no_cache) == true ? result_block.call :
        Rails.cache.fetch(fullpath, options) { result_block.call }

      render :text => result
    end
  end
end
