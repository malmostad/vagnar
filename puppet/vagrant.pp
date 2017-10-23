$envs = ['development', 'test']

$runner_name  = 'vagrant'
$runner_group = 'vagrant'
$runner_home  = '/home/vagrant'
$runner_path  = "${::runner_home}/.rbenv/shims:${::runner_home}/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin"

$app_name       = 'vagnar'
$app_home       = '/vagrant'

class { '::mcommons': }

class { '::mcommons::mysql':
  db_password      => '',
  db_root_password => '',
  create_test_db   => true,
  daily_backup     => false,
  ruby_enable      => true,
}

class { '::mcommons::memcached':
  memory => 16,
}

class { '::mcommons::ruby':
  version => '2.4.2',
}

# class { 'mcommons::ruby::bundle_install': }
class { 'mcommons::ruby::rails': }
