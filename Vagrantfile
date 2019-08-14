Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-16.04"
    config.vm.hostname = "scotchbox"
    config.vm.network "private_network", ip: "192.168.33.10"

    config.ssh.insert_key = false

    # Sync folders
    config.vm.synced_folder "../", "/var/www", :mount_options => ["dmode=777", "fmode=666"]
    config.vm.synced_folder "sites-enabled/", "/etc/apache2/sites-enabled"

    # Allocate more resources
    config.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 4
    end

    # SSH Agent Forwarding
    config.ssh.forward_agent = true

    # Provision
    config.vm.provision "shell", path: "install.sh", privileged: false
end
