define redis::instance (
  $socket_path     = undef,
  $user            = 'root',
  $group           = 'root',
  $template_config = 'redis/instance-config.conf',
  $configure_user  = true,
) {

  file { "/var/log/redis/redis-${name}.log":
    ensure => file,
    owner  => $user,
    group  => $group,
    mode   => 755,
  }

  $log_path = "/var/log/redis/redis-${name}.log"
  
  $bool_configure_user = true
  
  include redis

  file { "${redis::conf_prefix}${name}.conf":
    ensure   => file,
    content => template($template_config),
    notify  => Service["redis-${name}"],
  }

  file { "${redis::init_script}-${name}":
    ensure   => link,
    target   => $redis::init_script,
    before   => Service ["redis-${name}"]
  }
  
  file { "/etc/redis-${user}.user.conf":
      ensure   => file, 
      content => template('redis/userconfig.conf'),
      mode    => 755,
      before   => Service ["redis-${name}"]
    }

  service { "redis-${name}":
    hasstatus => true,
    ensure    => running,
  }

  if ($bool_configure_user == true) {
    # Make sure the user is member of the redis-multi group
    User <| title == $user |> { groups +> $::redis::group }
    realize User[$user]
    Group[$::redis::group] -> User[$user]
  }
}
