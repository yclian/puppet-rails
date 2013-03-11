source 'https://rubygems.org'

puppetversion = ENV['PUPPET_GEM_VERSION']

group :development, :test do
  gem 'puppetlabs_spec_helper', :github => 'puppetlabs/puppetlabs_spec_helper', :require => false
end

if puppetversion
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
