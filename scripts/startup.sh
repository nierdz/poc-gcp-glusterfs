#!/usr/bin/env bash
  
#set -o errexit
#set -o pipefail
#set -o nounset

apt install -y \
  bash-completion \
  gdebi-core \
  xfsprogs
parted /dev/sdb mktable gpt
parted /dev/sdb mkpart primary xfs 0% 100%
partprobe /dev/sdb
sleep 5
mkfs.xfs -f -i size=512 /dev/sdb1
mkdir -p /data/brick1
echo '/dev/sdb1 /data/brick1 xfs defaults 1 2' >> /etc/fstab
mount -a

wget -P /var/cache/apt/archives/ https://download.gluster.org/pub/gluster/glusterfs/LATEST/Debian/stretch/amd64/apt/pool/main/g/glusterfs/glusterfs-common_6.3-1_amd64.deb
wget -P /var/cache/apt/archives/ https://download.gluster.org/pub/gluster/glusterfs/LATEST/Debian/stretch/amd64/apt/pool/main/g/glusterfs/glusterfs-client_6.3-1_amd64.deb
wget -P /var/cache/apt/archives/ https://download.gluster.org/pub/gluster/glusterfs/LATEST/Debian/stretch/amd64/apt/pool/main/g/glusterfs/glusterfs-server_6.3-1_amd64.deb
gdebi --non-interactive /var/cache/apt/archives/glusterfs-common_6.3-1_amd64.deb
gdebi --non-interactive /var/cache/apt/archives/glusterfs-client_6.3-1_amd64.deb
gdebi --non-interactive /var/cache/apt/archives/glusterfs-server_6.3-1_amd64.deb

mkdir -p /data/brick1/gv0

if [ "$HOSTNAME" == "gluster-0" ];then
  gluster peer probe gluster-1
  gluster peer probe gluster-2
  gluster peer probe gluster-3
  gluster volume create gv0 replica 4 gluster-0:/data/brick1/gv0 gluster-1:/data/brick1/gv0 gluster-2:/data/brick1/gv0 gluster-3:/data/brick1/gv0
  gluster volume start gv0
fi

until gluster volume status gv0; do sleep 3; done
mount -t glusterfs "$HOSTNAME":/gv0 /mnt

sleep 1d
