#!/bin/bash

virt-install --name rhel-boot --os-variant rhel9.5 \
--vcpus 2 --ram 4096 --disk size=20 \
--network passt,portForward0=8122:22,portForward1=8180:80 \
--location ~/Downloads/rhel-9.6-x86_64-boot.iso \
--initrd-inject ./boot.ks \
--memorybacking source.type=memfd,access.mode=shared \
--filesystem $PWD/html,host-files,driver.type=virtiofs \
--graphics none \
--extra-arg console=ttyS0 \
--extra-args inst.ks=file:/boot.ks 