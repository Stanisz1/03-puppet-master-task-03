node 'slave1' 

  class { 'apache': }

  -> file {'/var/www/html/index.html':
  ensure => 'file',
  source => 'puppet:///modules/html/index.html',
  }

  -> apache::vhost { 'static':
  port          => '80',
  docroot       => '/var/www/html',
  }

}

node 'slave2' 

  class { 'apache': 
  default_vhost => false,
  }
  Package { ensure => 'installed' }
  package { 'php': }
  package { 'libapache2-mod-php': }

  
  -> file { '/var/www/html':
  ensure => 'directory',
  }

  -> file {'/var/www/html/index.php':
  ensure => 'file',
  source => 'puppet:///modules/php/files/index.php',
  }

  -> apache::vhost { 'dynamic':
  port          => '80',
  docroot       => '/var/www/html',
  }

}

node 'master.puppet' {
  include nginx

  file { '/etc/nginx/conf.d/default.conf':
   ensure => 'file',
   source => 'puppet:///modules/php/files/default.conf'
  }
  nginx::resource::server { 'static':
   listen_port => 80,
   proxy       => 'http://192.168.33.11:80',
  }
  nginx::resource::server { 'dynamic':
   listen_port => 80,
   proxy       => 'http://192.168.33.12:80',
  }
}


node 'mineserver.puppet'{
  include minecraft
} 
