require 'spec_helper'

describe 'rails::assets' do
  describe 'for apache' do
    let(:title) { 'apache' }

    it 'adds conf file for managing assets' do
      should contain_file('rails-assets-httpd').with(
        :ensure => 'present',
        :owner => 'root',
        :group => 'root',
        :path => '/etc/httpd/conf.d/rails-assets.conf',
        :source => 'puppet:///modules/rails/assets-httpd.conf',
        :require => 'Package[httpd]',
        :notify => 'Service[httpd]'
      )
    end
  end

  describe 'for nginx' do
    let(:title) { 'nginx' }

    it 'adds conf file for managing assets' do
      pending 'a way to specify `location` globally'

      should contain_file('rails-assets-nginx').with(
        :ensure => 'present',
        :owner => 'root',
        :group => 'root',
        :path => '/etc/nginx/conf.d/rails-assets.conf',
        :source => 'puppet:///modules/rails/assets-nginx.conf',
        :require => 'Package[nginx]',
        :notify => 'Service[nginx]'
      )
    end
  end
end
