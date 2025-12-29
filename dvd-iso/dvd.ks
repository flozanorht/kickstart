%pre --erroronfail
mkdir -p /mnt/host-var-srv
mount -t virtiofs -o ro host-var-srv /mnt/host-var-srv
%end

lang en_US.UTF-8
keyboard us
timezone Etc/UTC --utc

zerombr
clearpart --all --initlabel
reqpart --add-boot
part / --grow --fstype xfs

network --bootproto=dhcp

rootpw --lock

cdrom
text
reboot

%packages
@^Minimal Install
httpd
%end

%post --log=/var/log/anaconda/post-install.log --erroronfail

useradd -g wheel core
echo "core:redhat123" | chpasswd
mkdir /home/core/.ssh
cat > /home/core/.ssh/authorized_keys << EOFSSH
REPLACE_WTH_SSH_PUB_KEY
EOFSSH

echo "rhel-dvd" > /etc/hostname
chmod 644 /etc/hostname

systemctl enable httpd.socket
firewall-offline-cmd --zone=public --add-service=http
echo "RHEL VM installed offline" > /var/www/html/index.html
%end