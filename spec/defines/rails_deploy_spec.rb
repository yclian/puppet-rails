require 'spec_helper'

describe 'rails::deploy' do
  let(:title) { 'my-app' }
  let(:params) do
    {
      :app_name => 'my-rails-app',
      :deploy_path => '/opt/apps',
      :app_user => 'rails'
    }
  end

  it "creates user for running application" do
    should contain_user('rails').with(
      :system => true,
      :home => '/home/rails'
    )
  end

  it "creates the group for the user" do
    should contain_group('rails').with(
      :require => 'User[rails]'
    )
  end

  it "creates deploy area" do
    should contain_file('/opt/apps').with(
      :ensure => 'directory',
      :owner => 'rails',
      :group => 'rails',
      :mode => '0775',
      :require => 'User[rails]'
    )
  end

  it "creates folder for the application" do
    should contain_file('/opt/apps/my-rails-app').with(
      :ensure => 'directory',
      :owner => 'rails',
      :group => 'rails',
      :mode => '0775',
      :require => 'File[/opt/apps]'
    )
  end

  it 'does not add database.yml if adapter is not specified' do
    should_not contain_database('my-rails-app-db')
  end

  describe "without params" do
    let(:params) { Hash.new }
    it "defaults $deploy_path to '/data'" do
      should contain_file('/data')
    end

    it "defaults $app_user to 'deploy'" do
      should contain_user('deploy')
    end
  end

  describe 'can manage database.yml' do
    let(:title) { 'my-rails-app' }
    let(:params) do
      {
        :rails_env => 'staging',
        :database_adapter => 'mysql2',
        :database_name => 'my_rails_app_db',
        :database_user => 'rails',
        :database_password => 'sekrit',
        :database_charset => 'latin1',
        :database_host => 'db.app.com',
        :database_pool => 30
      }
    end

    it 'creates the shared/config folders' do
      should contain_file('/data/my-rails-app/shared').with(
        :ensure => 'directory',
        :owner => 'deploy',
        :group => 'deploy',
        :mode => '0775'
      )

      should contain_file('/data/my-rails-app/shared/config').with(
        :ensure => 'directory',
        :owner => 'deploy',
        :group => 'deploy',
        :mode => '0775'
      )
    end

    it 'if all required attributes are added' do
      should contain_file('my-rails-app-database.yml').with(
        :path => '/data/my-rails-app/shared/config/database.yml',
        :ensure => 'file',
        :owner => 'deploy',
        :group => 'deploy',
        :mode => '0644',
        :require => 'File[/data/my-rails-app]'
      )

      verify_contents(
        catalogue,
        'my-rails-app-database.yml',
        [
          'staging:',
          '  adapter: mysql2',
          '  database: my_rails_app_db',
          '  username: rails',
          '  password: sekrit',
          '  host: db.app.com',
          '  encoding: latin1',
          '  pool: 30'
        ]
      )
    end

    it 'ensuring database password are present' do
      params[:database_password] = 'UNSET'

      expect do
        should contain_file('my-rails-app-database.yml')
      end.to raise_error Puppet::Error, /database_password is required for database.yml/
    end
  end

  describe 'handles multiple applications run by the same user' do
    let(:pre_condition) { "rails::deploy { 'app1': }" }
    let(:title) { 'app2' }
    let(:params) { Hash.new }

    it 'by checking if the $app_user and $deploy_path are already defined' do
      should contain_rails__deploy('app1')
      should contain_rails__deploy('app2')
    end
  end

  describe 'has reasonable defaults' do
    let(:title) { 'my-rails-app' }
    let(:params) do
      {
        :database_adapter => 'mysql2',
        :database_password => 'sekrit'
      }
    end

    it 'for database.yml' do
      verify_contents(
        catalogue,
        'my-rails-app-database.yml',
        [
          'production:',
          '  adapter: mysql2',
          '  database: my_rails_app',
          '  username: deploy',
          '  password: sekrit',
          '  host: localhost',
          '  encoding: utf8',
          '  pool: 5'
        ]
      )
    end
  end
end
