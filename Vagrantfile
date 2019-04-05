# -*- mode: ruby -*-
# vi: set ft=ruby :



###     PROJECT INFO    ###
  #Goal: Implement a ""DevOps"" friendly dev environment with a full CI/CD pipeline

  #Current Progress:
    #When used with Vagrant+virtualbox, this file will create a VM that contains everything needed for php web development

  #Next Steps: 
    #CI/CD pipeline, probably with Jenkins

  #Stretch goals: 
    #Try a configuration or orchestration tool


###     HOW IM TESTING THIS     ###
  #I'm implementing this project using a project from another class, for authenticity.
  #for the senior capstone project: 
    #apache web server running a php+sqlite that connects to an iOS app

  #The Capstone project is a good fit for this because:
    #Strange dependencies that I won't need again
    #Team uses variety of dev environments
    #Product is being deployed to the customers web server, need to deploy safely



Vagrant.configure("2") do |config|

  #Choose box OS to use
  #OS needs to support php7
  config.vm.box = "ubuntu/xenial64"

  #forward host port 8080 to access port 80 on VM
  #can access VM web server at localhost:8080
  config.vm.network "forwarded_port", guest: 80, host: 8080


  #change the sync folder location to /var/www/html
  #so local changes automatically deploy
  config.vm.synced_folder ".", "/var/www/html",
    owner: "www-data",  
    group: "www-data",
    mount_options: ['dmode=755', 'fmode=755']

  
  # Provision Instructions
  # can be rerun with vagrant --provision
  # might switch to a configuration tool like puppet
  config.vm.provision "shell", inline: <<-SCRIPT
  
    echo -e "\nStarting Provision\n"

    echo -e "\nInstalling dependencies: apache2, php, sqlite\n"
    apt-get update
    apt-get install -y apache2 libapache2-mod-php php php-sqlite3 php-dev php-gd

    echo -e "\nRestarting services and finishing up\n"
    service apache2 restart

    SCRIPT
end
