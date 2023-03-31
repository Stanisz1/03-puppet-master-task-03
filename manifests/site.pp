node 'slave1' {
  file { '/root/README':
   ensure => 'absent', 
  }

  class { 'apache': }

  -> file {'/var/www/html/index.html':
  ensure => 'file',
  source => 'puppet:///modules/static/index.html',
  }

  -> apache::vhost { 'static':
  port          => '8080',
  docroot       => '/var/www/html',
  }

}

node 'slave2' {
  file { '/root/README':
   ensure => 'absent', 
  }

  class { 'apache': 
  default_vhost => false,
  }
  Package { ensure => 'installed' }
  package { 'php': }
  package { 'libapache2-mod-php': }
  package { 'php-mysql': }
  package { 'mariadb-server': }
  
  -> file { '/var/www/php':
  ensure => 'directory',
  }

  -> file {'/var/www/php/index.php':
  ensure => 'file',
  source => 'puppet:///modules/dynamic/index.php',
  }

  -> apache::vhost { 'dynamic':
  port          => '8081',
  docroot       => '/var/www/php',
  }

}

node 'master.puppet' {
  include nginx

  file { '/etc/nginx/conf.d/default.conf':
   ensure => 'file',
   source => 'puppet:///modules/dynamic/default.conf'
  }
  nginx::resource::server { 'static':
   listen_port => 8080,
   proxy       => 'http://192.168.33.11:80',
  }
  nginx::resource::server { 'dynamic':
   listen_port => 8081,
   proxy       => 'http://192.168.33.12:80',
  }
}


node 'mineserver.puppet'{
  include minecraft
} 
