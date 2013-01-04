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
end
