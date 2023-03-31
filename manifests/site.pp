node slave1 {
  package { 'httpd':
    ensure => installed,
    name   => httpd,
  }
  file { '/var/www/html/index.html':
    ensure => present,
    source => "puppet:///modules/html/index.html",
  }
  service { 'httpd':
    ensure => running,
    enable => true,
  }
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }
}

node slave2 {
  package { 'httpd':
    ensure => installed,
    name   => httpd,
  }
  package { 'php':
    ensure => installed,
    name   => php,
  }
  file { '/var/www/html/index.php':
    ensure => present,
    source => "puppet:///modules/php/files/index.php",
  }
  service { 'php-fpm':
    ensure => running,
    enable => true,
  }
  service { 'httpd':
    ensure => running,
    enable => true,
  }
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }
}

node master {
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }
  
  include nginx

  nginx::resource::server { '192.168.33.10':
    listen_port => 80,
    proxy => 'http://192.168.33.11',
  }
  nginx::resource::server { '192.168.33.10:81':
    listen_port => 81,
    proxy => 'http://192.168.33.12',
  }
  exec { 'config SELinux Booleans':
    command => 'setsebool -P httpd_can_network_connect on',
    path    => "/usr/sbin",
  }
}

node mineserver.puppet {
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }
  
  include minecraft
}
