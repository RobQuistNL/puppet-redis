class redis::params {
  
  $package = 'redis-server'
  
  $conf_prefix     = '/etc/redis-'
  $init_script     = '/etc/init.d/redis'
  
  $group           = 'redis'
  $user            = 'redis'
  
  $disable_default = false

}