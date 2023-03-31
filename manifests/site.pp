node 'slave1.puppet' {
   class { 'apache': }
  }
  file { '/var/www/html/index.html':
    ensure => present,
    source => "puppet:///modules/html/index.html",
  }
 

ode 'slave2.puppet' {
   class { 'apache::mod::php': }

   class { 'php': }

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

node 'master.puppet' {

include nginx

nginx::resource::server { 'static':
  listen_port => 80,
  proxy => 'http://192.168.33.11:80',
  }

nginx::resource::server { 'dynamic':
  listen_port => 81,
  proxy => 'http://192.168.33.12:80',
  }


exec { 'selinux_to_permissive':
  command     => 'setenforce 0',
  path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
  user       => 'root',
  }

exec { 'reboot_nginx':
  command     => 'systemctl restart nginx',
  path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
  user => 'root',
  }
}

node 'mineserver.puppet' {

 package {'java-17-openjdk':
  ensure => installed,
}

 file {'/opt/minecraft':
  ensure => directory,
}

 file {'/opt/minecraft/eula.txt':
  content => 'eula=true',
}

file { '/opt/minecraft/server.jar':
  ensure => file,
  source => 'https://piston-data.mojang.com/v1/objects/8f3112a1049751cc472ec13e397eade5336ca7ae/server.jar',
  replace => false,
     }

  file { '/etc/systemd/system/minecraft.service':
    owner => 'root',
    group => 'root',
    ensure => file,
    mode   => '0644',
    source => 'puppet:///modules/maincraft/files/service',
    replace => false,
    }


 ~> service { 'minecraft':
        ensure => running,
        enable => true
   }
}