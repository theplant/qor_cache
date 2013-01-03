module Qor
  class CacheController < ActionController::Base
    def includes
      fullpath = request.fullpath

      result = Rails.cache.fetch(fullpath) do
        path = params[:path]
        format = params["format"] || "html"
        file = Dir[File.join(Rails.root, "app/views/qor_cache_includes", "#{path}.#{format}*")][0]
        Erubis::Eruby.new(File.read(file)).result(binding)
      end

      render :text => result
    end
  end
end
