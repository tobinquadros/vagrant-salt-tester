# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Created with version 1.6.5, this may be extreme.
Vagrant.require_version ">= 1.6.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # GLOBAL VARIABLES
  # $base_box = "chef/centos-7.0"
  # $base_box = "chef/debian-7.6"
  # $base_box = "chef/opensuse-13.1"
  # $base_box = "terrywang/archlinux"
  $base_box = "ubuntu/trusty64"
  $vb_gui = false

  # MASTERLESS SETUP
  # Create Masterless node. You must call 'vagrant up masterless' to start this
  # node, and also to send it other vagrant commands.
  config.vm.define "masterless", autostart: false do |masterless|
    # BOX
    masterless.vm.box = $base_box
    # SYNCED FOLDERS
    # Add shared folders: "host_source_dir", "target_vm_dir", options
    masterless.vm.synced_folder "salt/file_roots/", "/srv/salt/", create: true
    # NETWORK
    masterless.vm.network "private_network", ip: "192.168.10.10"
    masterless.vm.host_name = "masterless"
    # PROVIDER
    masterless.vm.provider :virtualbox do |vb|
      # Set true to open in VB GUI for better debugging
      vb.gui = $vb_gui
      # If GUI, Virtualbox will title the window
      vb.name = "Salt Masterless Node"
      # Specify VM parameters before boot. :id required, see 'VBoxManage -h'
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    # PROVISION
    masterless.vm.provision :salt do |salt|
      salt.minion_config = "salt/masterless-minion"
      salt.run_highstate = true
    end
  end

  # SALT-MASTER SETUP
  # Create Salt-Master node. You must call 'vagrant up master' to start this
  # node, and also to send it other vagrant commands.
  config.vm.define "master", autostart: false do |master|
    master.vm.box = $base_box
    master.vm.synced_folder "salt/file_roots/", "/srv/salt/", create: true
    master.vm.network "private_network", ip: "192.168.10.11"
    master.vm.host_name = "salt"
    master.vm.provider :virtualbox do |vb|
      vb.gui = $vb_gui
      vb.name = "Salt Master Node"
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    master.vm.provision :salt do |salt|
      salt.install_master = true
      salt.no_minion = true
      salt.master_config = "salt/master"
      salt.master_key = "salt/key/master.pem"
      salt.master_pub = "salt/key/master.pub"
      salt.seed_master = {
        minion: "salt/key/minion.pub",
        master: "salt/key/master.pub",
      }
    end
  end

  # SALT-MINION SETUP
  # Create Salt-Minion node. You must call 'vagrant up minion' to start this
  # node, and also to send it other vagrant commands.
  config.vm.define "minion", autostart: false do |minion|
    minion.vm.box = $base_box
    minion.vm.network "private_network", ip: "192.168.10.12"
    minion.vm.host_name = "minion"
    minion.vm.provider :virtualbox do |vb|
      vb.gui = $vb_gui
      vb.name = "Salt Minion Node"
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    minion.vm.provision :salt do |salt|
      # The salt-master has to accept these keys, or preseed them.
      salt.minion_config = "salt/minion"
      salt.minion_key = "salt/key/minion.pem"
      salt.minion_pub = "salt/key/minion.pub"
      salt.run_highstate = true
    end
  end

end
