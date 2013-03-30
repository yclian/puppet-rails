#
define rails::assets(
  $server = $name
) {
  case $server {
    'httpd', 'apache': {
      file { 'rails-assets-httpd':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        path    => '/etc/httpd/conf.d/rails-assets.conf',
        source  => 'puppet:///modules/rails/assets-httpd.conf',
        require => Package['httpd'],
        notify  => Service['httpd'],
      }
    }

    # TODO: nginx does not allow global `location` blocks like apache does with
    # `<LocationMatch>`. These directives need to be specified within the
    # server they are applied to. An initial idea would be to specify the
    # augeas context and use augeas to specify the settings.
    # 'nginx': {
    #   file { 'rails-assets-nginx':
    #     ensure  => present,
    #     owner   => 'root',
    #     group   => 'root',
    #     path    => '/etc/nginx/conf.d/rails-assets.conf',
    #     source  => 'puppet:///modules/rails/assets-nginx.conf',
    #     require => Package['nginx'],
    #     notify  => Service['nginx'],
    #   }
    # }

    default: {
      fail("Web server ${server} is not supported")
    }
  }
}
