node 'slave1.puppet'{
  package {'httpd':
    ensure => installed,
}
  
  service {'firewalld':
    ensure => stopped,
}
  
  file { '/var/www/html/index.html':
    ensure => file,
    source => '/vagrant/index.html'
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
    source => '/vagrant/index.php'
}
  
  service {'httpd':
    ensure => running,
}  
}

node mineserver.puppet {
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }
include minecraft
}

node 'master.puppet'{

  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }

  include nginx
  
  nginx::resource::server {'static':
    listen_port => 80,
    proxy       => 'http://192.168.33.11',
}

  nginx::resource::server {'dynamic':
    listen_port => 81,
    proxy       => 'http://192.168.33.12',
}


 exec { 'config SELinux Booleans':
    command => 'setsebool -P httpd_can_network_connect on',
    path    => "/usr/sbin",
  }
}