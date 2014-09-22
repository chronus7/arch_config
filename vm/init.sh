#!/bin/bash
base="http://github.com/DaveAtGit/arch_config/raw/master/vm/"
curl -o arch_init.sh "${base}arch_init.sh"
curl -o arch_init_chroot.sh "${base}arch_init_chroot.sh"
chmod u+x arch_init*
./arch_init.sh
