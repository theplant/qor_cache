class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    render :index
  end

  def nocache
    render :nocache
  end
end
