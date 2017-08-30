$envs = ['production']

$runner_name  = 'app_runner'
$runner_group = 'app_runner'
$runner_home  = '/home/app_runner'
$runner_path  = "${::runner_home}/.rbenv/shims:${::runner_home}/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin"

$app_name       = 'vagnar'
$app_home       = "${::runner_home}/${::app_name}/current"

class { '::mcommons': }

class { '::mcommons::mysql':
  ruby_enable => true,
}

class { '::mcommons::memcached':
  memory => 128,
}

class { '::mcommons::nginx': }

class { '::mcommons::ruby':
  version => '2.4.1',
}

class { 'mcommons::ruby::unicorn': }
class { 'mcommons::ruby::rails': }
