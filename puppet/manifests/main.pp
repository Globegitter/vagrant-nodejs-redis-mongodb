Exec
{
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}


class apt_update {
    exec { "aptGetUpdate":
        command => "sudo apt-get update",
        path => ["/bin", "/usr/bin"]
    }
}

class othertools {
    package { "git":
        ensure => latest,
        require => Exec["aptGetUpdate"]
    }

    package { "vim-common":
        ensure => latest,
        require => Exec["aptGetUpdate"]
    }

    package { "curl":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }

    package { "htop":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }

    package { "g++":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }

    package { "vim":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }

    include apt
    apt::ppa {
    'ppa:fish-shell/release-2': notify => Package["fish"]
    }

    package { "fish":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }

    exec { "set-fish-default" :
      cwd => "/vagrant",
      #command => "sudo chsh -s /usr/bin/fish",
      command => "chsh -s /usr/bin/fish",
      require => Package['fish']
      user => "vagrant"
    }
}

$nodepath = ["/usr/local/node/node-default/bin", "/usr/local/sbin", "/usr/local/bin",
"/usr/sbin", "/usr/bin", "/sbin", "/bin", "/usr/games", "/opt/vagrant_ruby/bin"]

class node-js {
  include apt
  apt::ppa {
    'ppa:chris-lea/node.js': notify => Package["nodejs"]
  }

  package { "nodejs" :
      ensure => latest,
      require => [Exec["aptGetUpdate"],Class["apt"]]
  }

  exec { "npm-update" :
      cwd => "/vagrant",
      command => "npm -g update",
      #onlyif => ["test -d /vagrant/node_modules"],
      path => $nodepath,
      require => Class['nodejs'],
      user => "vagrant"
  }

   exec { "npm-sails" :
      cwd => "/vagrant",
      command => "npm install -g sails@beta",
      #onlyif => ["test -d /vagrant/node_modules"],
      #path => ["/bin", "/usr/bin"],
      path => $nodepath,
      require => Class['nodejs'],
      user => "vagrant"
  }

  exec { "npm-forever" :
      cwd => "/vagrant",
      command => "npm install -g forever",
      #onlyif => ["test -d /vagrant/node_modules"],
      #path => ["/bin", "/usr/bin"],
      path => $nodepath,
      require => Class['nodejs'],
      user => "vagrant"
  }

  exec { "npm-inspector" :
      cwd => "/vagrant",
      command => "npm install -g node-inspector",
      #onlyif => ["test -d /vagrant/node_modules"],
      #path => ["/bin", "/usr/bin"],
      path => $nodepath,
      require => Class['nodejs'],
      user => "vagrant"
  }
}

class mongodb {
  exec { "mongodbKeys":
    command => "sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10",
    path => ["/bin", "/usr/bin"],
    notify => Exec["aptGetUpdate"],
    unless => "apt-key list | grep mongodb"
  }

  file { "mongodb.list":
    path => "/etc/apt/sources.list.d/mongodb.list",
    ensure => file,
    content => "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen",
    notify => Exec["mongodbKeys"]
  }

  package { "mongodb-org":
    ensure => present,
    require => [Exec["aptGetUpdate"],File["mongodb.list"]]
  }
}


class redis-cl {
  class { 'redis': }
}

include apt_update
include othertools
#include node-js
include mongodb
include redis-cl
include mysql
include nodejs
#include phpmyadmin
