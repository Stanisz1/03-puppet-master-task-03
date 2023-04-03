class minecraft {
  package {'java-17-openjdk':
    ensure => installed
    }

 file {'/opt/minecraft':
   ensure => directory
   }

file {'/opt/minecraft/eula.txt':
  ensure => file,
  content => 'eula=true'
     }
     

file { '/opt/minecraft/server.jar':
  ensure => file,
  source => 'https://piston-data.mojang.com/v1/objects/8f3112a1049751cc472ec13e397eade5336ca7ae/server.jar',
  replace => false,
     }

file {'/etc/systemd/system/minecraft.service':
   ensure => file,
   source => 'puppet:///modules/minecraft/files/minecraft.service'
   }

 ~> service { 'minecraft':
        ensure => running,
        enable => true
   }
}
