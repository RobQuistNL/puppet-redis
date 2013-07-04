class redis (
  $package         = params_lookup('package'),
  $user            = params_lookup('user'),
  $group           = params_lookup('group'),
  $disable_default = params_lookup('disable_default'),
) inherits redis::params {
  
  $bool_disable_default = any2bool($disable_default)

  package { $package: }

  file { '/etc/init.d/redis':
    content => template('redis/init.sh'),
    mode    => 0551,
    owner   => root,
    group   => root,
  }
  
  file { '/var/run/redis':
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => 1771,
  }
  
  file { '/usr/share/redis':
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => 1771,
  }
  
  
  file { '/usr/share/redis/scripts':
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => 1771,
  }
  
  group { 'redis':
    system => true,
  }

  user { 'redis':
    system  => true,
  }

  file { '/usr/share/redis/scripts/start-redis':
    content => template('redis/startscript.sh'),
    mode    => 755,
  }
  
  if ($bool_disable_default == true) {
    file { '/etc/redis/redis.conf': 
      ensure => absent
    }
    
  }
  
}
