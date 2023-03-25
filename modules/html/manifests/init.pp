class html {
  package {['httpd']:
    ensure => installed
  }
  
  file { '/var/www/html':
    ensure => directory
  }
  
  file { '/var/www/html/index.html':
    ensure => file,
    source => 'puppet:///modules/html/index.html'
  }
  
 
 service {'httpd':
    ensure => running
 }
}