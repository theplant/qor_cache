module Qor
  class CacheController < ActionController::Base
    include Qor::CacheHelper

    def includes
      render :text => render_qor_cache_includes(params[:path], request.fullpath)
    end
  end
end
