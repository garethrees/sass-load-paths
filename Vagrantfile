$provision = <<-EOF
function install {
  echo installing $1
  shift
  apt-get -y install "$@" >/dev/null 2>&1
}
#
apt-get -y update >/dev/null 2>&1

install 'development tools' build-essential

echo installing Bundler

install Git git
install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev
install 'Blade dependencies' libncurses5-dev
install 'ExecJS runtime' nodejs
EOF

$install_rvm = <<-EOF
#!/usr/bin/env bash
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s $1
EOF

$install_ruby = <<-EOF
#!/usr/bin/env bash

source $HOME/.rvm/scripts/rvm

rvm use --default --install $1

shift

if (( $# ))
then gem install $@
fi

rvm cleanup all
EOF

RUBYDEV_IP = ENV['RUBYDEV_IP'] || '192.168.33.45'
RUBYDEV_MEMORY = ENV['RUBYDEV_MEMORY'] || '512'

VAGRANTFILE_API_VERSION = 2

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu-1404'
  config.vm.box_url = 'http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'

  # config.vm.network :private_network, ip: RUBYDEV_IP
  # config.vm.network :forwarded_port, guest: 22, host: 1234

  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.customize ['modifyvm', :id, '--memory', RUBYDEV_MEMORY]
    virtualbox.customize ['modifyvm', :id, '--cpus', `sysctl -n hw.ncpu`.to_i]
  end

  config.ssh.forward_agent = true

  config.vm.provision :shell, inline: $provision
  config.vm.provision :shell, inline: $install_rvm, args: 'stable', privileged: false
  config.vm.provision :shell, inline: $install_ruby, args: '1.9.3 bundler', privileged: false
end
