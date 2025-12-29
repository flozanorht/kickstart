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

mkdir -p /mnt/host-files
mount -t virtiofs -o ro host-files /mnt/host-files
cp /mnt/host-files/index.html /var/www/html
%end