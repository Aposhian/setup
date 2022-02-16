Vagrant.configure("2") do |config|
    name = "ubuntu20"
    config.vm.define name do |config|
        config.vm.hostname = name
        config.vm.box = "generic/ubuntu2004"
        config.vm.provision "shell", path: "./scripts/install-ansible.sh"
    end
end
