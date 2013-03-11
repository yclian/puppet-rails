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

This will setup add the user `rails` and create the directory `/var/www/rails/my-app-name` owned by `rails`.  

If relevant, you can manage the `database.yml` for your application by specifying the relevant parameters:

```puppet
rails::deploy { 'my-app':
  database_adapter  => 'mysql2',
  database_host     => 'db.app.com',
  database_user     => 'rails_db',
  database_password => 'sekrit',
  database_charset  => 'latin1',
}
```

The database name is assumed to be the name of the application.
