class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    render :index
  end

  def nocache
    render :nocache
  end

  def expires_in
    render :expires_in
  end

  def products
    render :products
  end

  def helpers
    render :helpers
  end

  def with_block
    render :with_block
  end
end
