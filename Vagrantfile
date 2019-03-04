module LocalCommand
  class Config < Vagrant.plugin("2", :config)
    attr_accessor :command
  end

  class Plugin < Vagrant.plugin("2")
    name "local_shell"

    config(:local_shell, :provisioner) do
      Config
    end

    provisioner(:local_shell) do
      Provisioner
    end
  end

  class Provisioner < Vagrant.plugin("2", :provisioner)
    def provision
      result = system "#{config.command}"
    end
  end
end

Vagrant.configure("2") do |config|
  config.vm.box = "eugenmayer/opnsense"

  config.ssh.sudo_command = "%c"
  config.ssh.shell = "/bin/sh"
  config.ssh.password = "opnsense"
  config.ssh.username = "root"
  config.ssh.port = "10022"
  # we need to use rsync, no vbox drivers for bsd
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define 'opnsense', autostart: false do |test|
    test.vm.provider 'virtualbox' do |vb|
      vb.customize ['modifyvm',:id, '--nic1', 'intnet', '--nic2', 'nat'] # swap the networks around
      vb.customize ['modifyvm', :id, '--natpf2', "ssh,tcp,127.0.0.1,10022,,22" ] #port forward
      vb.customize ['modifyvm', :id, '--natpf2', "https,tcp,127.0.0.1,10443,,443" ] #port forward
      vb.customize ['modifyvm', :id, '--natpf2', "openvpn_tcp,tcp,127.0.0.1,11194,,1194" ] # openvpn tcp
      vb.customize ['modifyvm', :id, '--natpf2', "openvpn_udp,udp,127.0.0.1,11194,,1194" ] # openvpn udp
      #vb.customize ['modifyvm', :id, '--natpf1', "https,tcp,127.0.0.1,1443,,443" ] #port forward
    end

    # install dev tools
    test.vm.provision "shell",
      inline: "pkg update && pkg install -y joe nano gnu-watch git tmux screen",
      run: "once"


    test.vm.synced_folder "./vendor/core", "/root/core", type: "rsync",
        rsync__chown: false,
        rsync__exclude: "./core/.git/"

    # replace the public ssh key for the root user with the one vagrant deployed for comms before we restart - or we lock vagrant out
    test.vm.provision "inject-pubkey-into-config", type: "local_shell", command: "export PUB=$(ssh-keygen -f .vagrant/machines/opnsense/virtualbox/private_key -y | base64) && xmlstarlet ed --inplace -u '/opnsense/system/user/authorizedkeys' -v \"$PUB\" config-openvpn.xml"
    # apply our configuration so we have a configured openvpn and such
    test.vm.provision "file", source: "./config-openvpn.xml", destination: "/conf/config.xml"

    #test.vm.provision "inject-pubkey-into-config", type: "local_shell", command: "export PUB=$(ssh-keygen -f .vagrant/machines/opnsense/virtualbox/private_key -y | base64) && xmlstarlet ed --inplace -u '/opnsense/system/user/authorizedkeys' -v \"$PUB\" config-default.xml"
    #test.vm.provision "file", source: "./config-default.xml", destination: "/conf/config.xml"

    test.vm.provision "shell",
      inline: "echo 'rebooting to apply config' && reboot"

    test.vm.provision "sleep-for-reboot", type: "local_shell", command: "echo 'waiting for the reboot' && sleep 50"

    # this will register our local core from source and let opnsense run from that
    # @see https://wiki.opnsense.org/development/workflow.html
    test.vm.provision "shell", inline: "cd /root/core && make package && service configd restart && (make mount || true) && make mount"

    # test.vm.provision "shell", inline: "cd /root/plugins/net/openvpn && make package && pkg add work/pkg/*.txz"
  end
end
