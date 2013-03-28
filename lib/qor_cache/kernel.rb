require 'timeout'
require "digest/md5"
require 'uri'

module Kernel
  def qor_cache_key(*names, &blk)
    Timeout::timeout(1) do
      objs = names.map { |name| Qor::Cache::Configuration.first(:cache_key, name).block.call }
      objs << instance_eval(&blk) if block_given?

      results = objs.flatten.map do |obj|
        obj.respond_to?(:cache_key) ? obj.cache_key : obj.inspect
      end

      Digest::MD5.hexdigest(results.join("-"))
    end
  rescue
    puts $!
    rand.to_s
  end
end
