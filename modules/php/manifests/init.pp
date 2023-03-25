class php {
  package {['httpd', 'php']:
    ensure => installed
  }
  
  file { '/var/www/php':
    ensure => directory
  }
  
  file { '/var/www/php/index.php':
    ensure => file,
    source => 'puppet:///modules/php/index.php'
  }
  
  file { '/etc/httpd/conf.d/php.conf':
    ensure => file,
    source => 'puppet:///modules/php/php.conf',
    notify => Service['httpd']
  }

 service {'httpd':
    ensure => running
 }
}