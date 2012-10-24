source 'https://rubygems.org'
gemspec

# Run your tests with nokogiri's 1.4 branch and master branch
gem  'nokogiri', :git => "git://github.com/sparklemotion/nokogiri.git", :branch => "1.4"
gem  'nokogiri', :git => "git://github.com/sparklemotion/nokogiri.git", :branch => "master"

# You can also write above code in one line like this
gem  'nokogiri', [{:git => "git://github.com/sparklemotion/nokogiri.git"}, {:git => "git://github.com/sparklemotion/nokogiri.git", :branch => "1.4"}]

# Default mode, your tests will run with rails 3.1, 3.2 and 4.0
# So with above config, your tests will run 6 times
# [nokogiri(1.4), rails(3.1)], [nokogiri(master), rails(3.1)]
# [nokogiri(1.4), rails(3.2)], [nokogiri(master), rails(3.2)]
# [nokogiri(1.4), rails(4.0)], [nokogiri(master), rails(4.0)]
env 'default' do
  ruby '1.9.3'
  gem  'rails', ['3.1', '3.2', '4.0']
end

# Using `qor_test -e old_ruby -c 'rake test'` to run your tests in old_ruby mode
env 'old_ruby' do
  ruby 'ree'
  gem  'rails', ['3.1', '3.2']
end
