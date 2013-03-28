source 'https://rubygems.org'
gemspec

# TODO test rails v4.0, make qor_test compatible with it first.
gem 'rails', [3.1, 3.2]

env '2.0' do
  ruby '2.0'
end

env '1.9.3' do
  ruby '1.9.3'
end

env '1.8.7' do
  ruby '1.8.7'
  gem 'factory_girl_rails', '1.3.0'
end
