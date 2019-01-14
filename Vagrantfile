# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "sbeliakou/centos-7.5-x86_64-minimal"
  config.vm.box_version = "1.0"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    yum update -y
    printf "[advance-toolchain]\nname=Advance Toolchain Unicamp FTP\nbaseurl=ftp://ftp.unicamp.br/pub/linuxpatch/toolchain/at/redhat/RHEL7\nfailovermethod=priority\nenabled=1\ngpgcheck=1\ngpgkey=ftp://ftp.unicamp.br/pub/linuxpatch/toolchain/at/redhat/RHEL7/gpg-pubkey-6976a827-5164221b\n" > /etc/yum.repos.d/at9.0.repo
    yum update -y
    wget ftp://ftp.unicamp.br/pub/linuxpatch/toolchain/at/redhat/RHEL7/gpg-pubkey-6976a827-5164221b
    rpm --import gpg-pubkey-6976a827-5164221b
    yum install advance-toolchain-at12.0-cross-ppc64le.x86_64 -y
  SHELL

end
