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
  $app_name = $name,
  $deploy_path = '/data',
  $app_user = 'deploy'
) {

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

  file { "${deploy_path}/${app_name}":
    ensure  => directory,
    owner   => $app_user,
    group   => $app_user,
    mode    => '1775',
    require => File[$deploy_path],
  }
}
