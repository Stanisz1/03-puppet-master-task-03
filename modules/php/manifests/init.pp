class php {
  package {['httpd', 'php']:
    ensure => installed
  }
  
  file { '/var/www/html':
    ensure => directory
  }
  
  file { '/var/www/html/index.php':
    ensure => file,
    source => 'puppet:///modules/php/index.php'
  }
  
 service {'httpd':
    ensure => running
 }
}
