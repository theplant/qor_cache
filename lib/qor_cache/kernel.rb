require "digest/md5"

module Kernel
  def qor_cache_key(name)
    results = Qor::Cache::Configuration.first(:cache_key, name).block.call
    results = Array(results)
    results = results.map {|x| x.respond_to?(:cache_key) ? x.cache_key : x.inspect }.join("-")
    Digest::MD5.hexdigest(results)
  rescue
    puts $!
    rand()
  end
end
