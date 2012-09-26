require 'spec_helper'

describe 'rails::deploy' do
  let(:title) { 'my-app' }
  let(:params) { { :app_name => 'my-rails-app', :deploy_path => '/opt/apps', :app_user => 'rails' } }

  it "creates user for running application" do
    should contain_user('rails').with(
      :system => true,
      :home => '/home/rails'
    )
  end

  it "creates the group for the user" do
    should contain_group('rails').with(
      :require => 'User[rails]',
    )
  end

  it "creates deploy area" do
    should contain_file('/opt/apps').with(
      :owner => 'rails',
      :group => 'rails',
      :mode => '1775',
      :require => 'User[rails]'
    )
  end

  it "creates folder for the application" do
    should contain_file('/opt/apps/my-rails-app').with(
      :owner => 'rails',
      :group => 'rails',
      :mode => '1775',
      :require => 'File[/opt/apps]'
    )
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
end
