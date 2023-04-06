class minecraft{
  package {'java-17-openjdk':
    ensure => installed,
}

  file {'/opt/minecraft':
    ensure => directory,
}

  file {'/opt/minecraft/eula.txt':
    ensure => file,
    source => '/vagrant/eula.txt',
}

  file {'/opt/minecraft/server.jar':
    ensure => file,
    replace => false,
    source => 'https://piston-data.mojang.com/v1/objects/8f3112a1049751cc472ec13e397eade5336ca7ae/server.jar',
}

  file {'/etc/systemd/system/minecraft.service':
    ensure => file,
    source => '/vagrant/minecraft.service',
}

 ~> service {'minecraft.service':
      ensure => running,
}
}