require "digest/md5"
require 'uri'

module Kernel
  def qor_cache_key(*names, &blk)
    objs = names.map { |name| Qor::Cache::Configuration.first(:cache_key, name).block.call }
    objs << blk.call if block_given?

    results = objs.map do |obj|
      Array(obj).map {|x| x.respond_to?(:cache_key) ? x.cache_key : x.inspect }.join("-")
    end

    Digest::MD5.hexdigest(results.join("-"))
  rescue
    puts $!
    rand()
  end

  def render_qor_cache_includes(filename)
    env = respond_to?(request) && request.respond_to?(:env) ? request.env : {}
    path = URI.parse(filename).path resuce filename
    key = "/qor_cache_includes/#{filename}"
    # Qor::Cache::Configuration.deep_find(:cache_includes, path)[0]

    if env['QOR_CACHE_SSI_ENABLED']
      %Q[<!--# include virtual="#{key}" -->]
    elsif env['QOR_CACHE_ESI_ENABLED']
      %Q[<esi:include src="#{key}"/>]
    else
    end
  end
end
