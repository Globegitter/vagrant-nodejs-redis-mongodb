# Vagrant and Puppet configuration for SailsJS

Vagrant configuration with puppet to create a Virtual Box machine with 
Ubuntu Server 14.04, Nodejs v0.10.\*, Redis stable release, MongoDB 
2.6.\*

##Setup
* Clone the repository `git clone https://github.com/Globegitter/vagrant-nodejs-redis-mongodb.git`.
* Run `vagrant up` and wait until everything gets downoaded and installed.
* SSH in with `vagrant ssh`.
* `cd /var/www` and `rm .gitignore`.
* Then run `sails new .` or `sails new . --linker` if you are planning to use https://github.com/cashbit/sails-crudface.
* Add a `.foreverignore` with `**/.tmp/**` and `**/views/**` in this folder, so forever only auto-reloads the Server when needed.
* Run `forever -w start app.js`, this ensures that the server runs all the time and updates on any code change.
* Run `sails generate api user` or whatever - Happy coding!
* Shut down with `vagrant halt`.


##Access from your local machine

* redis.cli h 192.168.33.10 -p 6379
* mongo 192.168.33.10
* MySQL `mysql -h 127.0.0.1 -P 7778 -u root`
* SailsJS Server `localhost:1337`

##Requirements:
* Get the latest VirtualBox - Free virtualization software [Download Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* Get the latest Vagrant- Tool for working with virtualbox images [Download Vagrant](https://www.vagrantup.com)

Puppet Manifest will install:
[Nodejs - v0.10.\*, Redis - last stable release, MongoDB - 2.6.\*, MySQL, SailsJS 0.10.x, forever, node-inspector, wget, 
git, vim, htop, g++, fish]

##Roadmap
* Hopefully can automate some more of the steps in the future.
