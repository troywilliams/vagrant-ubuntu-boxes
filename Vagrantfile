# -*- mode: ruby -*-
# vi: set ft=ruby :

# https://docs.vagrantup.com.
Vagrant.configure(2) do |config|

  # Make sure we have project name to continue.
  if !ENV.has_key?("PROJECT")
      raise "Please specify the `PROJECT` environment variable"
  end

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Port forwarded local network configuration.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Private local network configuration.
  # config.vm.network "private_network", ip: "192.168.3.100"

  # Landrush local network configuration.
  config.vm.hostname = ENV["PROJECT"] + ".vagrant.dev"
  config.landrush.upstream '8.8.8.8' # Google as upstream DNS.
  config.landrush.guest_redirect_dns = false
  config.landrush.enabled = true


  # SSH Agent forwarding.
  config.ssh.forward_agent = true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant.
  config.vm.provider "virtualbox" do |vb|
     vb.name = ENV["PROJECT"]
     # Customize the amount of memory on the VM:
     vb.memory = "1028"
     # CPU execution cap of %50 on host.
     vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end

  config.vm.provision "shell", path: "basebox.sh", args: ENV["PROJECT"]
end