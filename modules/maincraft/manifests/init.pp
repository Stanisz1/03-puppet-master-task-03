class maincraft {   
 
 file { '/opt/minecraft/':
    ensure => directory  
  }  
 
  file { "/opt/minecraft/newjava.rpm":
  source => [
    "https://download.oracle.com/java/18/latest/jdk-18_linux-x64_bin.rpm",
  ]
}

exec {'install_java_rpm' :
    path    => ['/usr/bin', '/usr/sbin', '/bin'],
    command   => "/usr/bin/rpm -ivh /opt/minecraft/newjava.rpm",    
  }
    
  file { "/opt/minecraft/server.jar":
  source => [
    "https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar",
  ]
}

  file { '/home/vagrant/eula.txt':
    ensure => file,
    source => 'puppet:///modules/maincraft/eula.txt'
  }
  
  file { "/etc/systemd/system/minecraft.service":
  source => [
    "https://raw.githubusercontent.com/Stanisz1/devops-hometasks/master/03-puppet/minecraft.service",
  ]
}

    service { 'minecraft':
    ensure => 'running',
  }

 }
