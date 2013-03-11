# = define: rails_deploy
#
# Sets up basic requirements for a deploy:
#   * user to run the application as
#   * create directory to deploy app to
#
# Does not handle creating current, releases or shared directories. Capistrano
# already handles that.
#
# == Parameters:
#
# $app_name:: name of the application. Used in the default $deploy_path,
#   "/data/${app_name}". Defaults to the name of the resource.
# $deploy_path:: where the application will be deployed. Defaults to '/data'
# $app_user:: name of the system user to create to run the application as.
#   Defaults to 'deploy'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   rails_deploy { 'todo-list':
#     app_user => 'passenger',
#     deploy_path => '/var/lib/passenger,
#   }
#
define rails::deploy(
  $app_name          = $name,
  $deploy_path       = '/data',
  $app_user          = 'deploy',
  $rails_env         = 'production',
  $database_host     = 'localhost',
  $database_adapter  = 'UNSET',
  $database_user     = 'UNSET',
  $database_password = 'UNSET',
  $database_charset  = 'utf8'
) {
  $app_path = "${deploy_path}/${app_name}"

  user { $app_user :
    ensure     => present,
    system     => true,
    managehome => true,
    home       => "/home/${app_user}",
  }

  group { $app_user :
    ensure  => present,
    require => User[$app_user],
  }

  file { $deploy_path :
    ensure  => directory,
    owner   => $app_user,
    group   => $app_user,
    mode    => '1775',
    require => User[$app_user],
  }

  file { $app_path:
    ensure  => directory,
    owner   => $app_user,
    group   => $app_user,
    mode    => '1775',
    require => File[$deploy_path],
  }

  if $database_adapter != 'UNSET' {
    if $database_password == 'UNSET' {
      fail('database_password is required for database.yml')
    }

    if $database_user == 'UNSET' {
      $database_user_real = $app_user
    } else {
      $database_user_real = $database_user
    }

    file { "${app_name}-database.yml":
      path    => "${app_path}/shared/config/database.yml",
      ensure  => present,
      owner   => $app_user,
      group   => $app_user,
      content => template('rails/database.yml.erb'),
      mode    => '0644',
      recurse => true,
      require => File[$app_path],
    }
  }
}
