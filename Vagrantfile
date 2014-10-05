# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# If you want vagrant to bootstrap the nodes use:
#   $ vagrant plugin install vagrant-salt
# The vagrant-salt plugin requires a version greater than 1.3, if it's used.
Vagrant.require_version ">= 1.3.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  ###
  # GLOBAL VARIABLES
  ###
  # $base_box = "ubuntu/trusty64"
  # $base_box = "chef/debian-7.6"
  # $base_box = "chef/centos-7.0"
  $base_box = "chef/centos-6.5"
  $vb_gui = false

  ###
  # MASTERLESS SETUP
  ###
  # Create a Masterless Minion node only. This is the default for this
  # Vagrantfile when you call 'vagrant up' with no arguments.
  config.vm.define "masterless", primary: true do |masterless|
    # BOX
    masterless.vm.box = $base_box
    # SYNCED FOLDERS
    # The file_roots 'base:' environment defaults to the /srv/salt/ directory.
    # You must have a 'base:' env with a top.sls. You can share State Trees
    # from the file_roots/ dir of this project like a master node.
    # Add shared folders: "host_source_dir", "target_vm_dir", options
    masterless.vm.synced_folder "file_roots/", "/srv/salt/", create: true
    # NETWORK
    # Expose some ports from the host, can be UDP or TCP. Not required.
    masterless.vm.network :forwarded_port, host: 8080, guest: 80, auto_correct: true
    masterless.vm.host_name = "masterless"
    # PROVIDER
    masterless.vm.provider :virtualbox do |vb|
      # Open in Virtualbox GUI for boot debugging?
      vb.gui = $vb_gui
      # If so, Virtualbox will title the window with:
      vb.name = "Salt Masterless Node"
      # Specify VM parameters before boot. :id required, see 'VBoxManage -h'.
      vb.customize ["modifyvm", :id, "--memory", "2048"]
    end
    # PROVISION
    masterless.vm.provision :salt do |salt|
      salt.minion_config = "config/masterless-minion"
      salt.run_highstate = true
    end
  end

  ###
  # SALT-MASTER SETUP
  ###
  # Create Salt-Master node. You must call 'vagrant up master' to start this
  # node, and also to send it other vagrant commands. Example: To begin testing
  # a Master-Minion setup use 'vagrant up master minion' then 'vagrant ssh master'.
  config.vm.define "master", autostart: false do |master|
    # BOX
    master.vm.box = $base_box
    # SYNCED FOLDERS
    master.vm.synced_folder "file_roots/", "/srv/salt/", create: true
    # NETWORK
    master.vm.network :private_network, ip: "192.168.10.100"
    master.vm.network "public_network", :bridge => 'en1: Wi-Fi (Airport)'
    master.vm.host_name = "salt"
    # PROVIDER
    master.vm.provider :virtualbox do |vb|
      # Open in Virtualbox GUI for boot debugging?
      vb.gui = $vb_gui
      # If so, Virtualbox will title the window with:
      vb.name = "Salt Master Node"
      # Specify VM parameters before boot. :id required, see 'VBoxManage -h'.
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    # PROVISION
    master.vm.provision :shell do |shell|
      # Build only the salt-master package from latest git.
      shell.inline = "curl -L https://bootstrap.saltstack.com | sudo sh -s -- -M -N git develop"
    end
  end

  ###
  # SALT-MINION SETUP
  ###
  # Create Salt-Minion node. You must call 'vagrant up minion' to start this
  # node, and also to send it other vagrant commands. Example: To begin testing
  # a Master-Minion setup use 'vagrant up master minion' then 'vagrant ssh minion'.
  config.vm.define "minion", autostart: false do |minion|
    # BOX
    minion.vm.box = $base_box
    # NETWORK
    # Enable private network, could use DHCP. :bridge not required.
    minion.vm.network :private_network, ip: "192.168.10.101"
    minion.vm.network "public_network", :bridge => 'en1: Wi-Fi (Airport)'
    minion.vm.host_name = "minion"
    # PROVIDER
    minion.vm.provider :virtualbox do |vb|
      # Open in Virtualbox GUI for boot debugging?
      vb.gui = $vb_gui
      # If so, Virtualbox will title the window with:
      vb.name = "Salt Minion Node"
      # Specify VM parameters before boot. :id required, see 'VBoxManage -h'.
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    # PROVISION
    minion.vm.provision :salt do |salt|
      salt.run_highstate = true
      salt.minion_config = "./minion.conf"
      salt.minion_key = "./minion.pem"
      salt.minion_pub = "./minion.pub"
    end
  end

end
