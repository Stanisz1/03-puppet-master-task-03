
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


class { selinux:
    mode => 'permissive',
    type => 'targeted',
}

  exec {'restart_nginx':
    command     => 'systemctl restart nginx',
    path        => ['/bin'],
    user => 'root',
} 
}

node 'slave1.puppet'{
  package {'httpd':
    ensure => installed,
}
  
  service {'firewalld':
    ensure => stopped,
}
  
  file { '/var/www/html/index.html':
    ensure => file,
    source => 'puppet:///modules/html/index.html'
}
   
  service {'httpd':
    ensure => running,
}
}

 

node 'slave2.puppet'{
  package {'httpd':
    ensure => installed,
}
  
  package {'php':
    ensure => installed,
}
  
  service {'firewalld':
    ensure => stopped,
} 
  file {'/var/www/html/index.php':
    ensure => file,
    source => 'puppet:///modules/php/files/index.php'
}
  
  service {'httpd':
    ensure => running,
}  
}


node 'mineserver.puppet' {

 service {'firewalld':
    ensure => stopped,
} 

  class { selinux:
    mode => 'permissive',
    type => 'targeted',
}
  
  include minecraft 
}