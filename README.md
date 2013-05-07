# puppet-rails

[![Build Status](https://travis-ci.org/ecbypi/puppet-rails.png?branch=master)](https://travis-ci.org/ecbypi/puppet-rails)

Allows you to manage your Rails deploys.

## Setup environment

Use the `rails::deploy` resource type to add your application user and create
your deploy path:

```puppet
rails::deploy { 'my-app-name':
  deploy_path => '/var/www/rails',
  app_user    => 'rails',
}
```

This will setup add the user `rails` and create the directory
`/var/www/rails/my-app-name` owned by `rails`. If `var` or `/var/www` do not
exist, they will be created and owned by the deploy user.

### database.yml

If relevant, you can manage the `database.yml` for your application by
specifying the relevant parameters:

```puppet
rails::deploy { 'my-app':
  rails_env         => 'staging',
  database_adapter  => 'mysql2',
  database_name     => 'my_app_db',
  database_host     => 'db.app.com',
  database_user     => 'rails_db',
  database_password => 'sekrit',
  database_charset  => 'latin1',
  database_pool     => 12,
}
```

Only `database_adapter` and `database_password` are required. The
`database_name` defaults to the application name underscored.
