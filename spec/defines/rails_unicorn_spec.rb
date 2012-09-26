require 'spec_helper'

describe 'rails::unicorn' do
  let(:title) { 'my-rails-app' }
  let(:params) do
    {
      :app_user => 'rails',
      :deploy_path => '/opt/apps',
      :pid_path => '/var/run',
      :config_path => '/etc/unicorn'
    }
  end

  it "sets up a rails deploy" do
    should contain_rails__deploy('my-rails-app').with(
      :deploy_path => '/opt/apps',
      :app_user => 'rails'
    )
  end

  it "creates init script" do
    should contain_file('unicorn-init-my-rails-app').with(
      :path => '/etc/init.d/unicorn-my-rails-app',
      :owner => 'root',
      :group => 'root',
      :mode => '0755'
    )
  end

  it "enables unicorn service for the app" do
    should contain_service('unicorn-my-rails-app').with(
      :enable => true,
      :require => 'Rails::Deploy[my-rails-app]'
    )
  end

  describe "without params" do
    let(:params) { Hash.new }

    it "defaults $deploy_path to '/data' and $app_user to 'deploy'" do
      should contain_rails__deploy('my-rails-app').with(
        :deploy_path => '/data',
        :app_user => 'deploy'
      )
    end
  end
end
