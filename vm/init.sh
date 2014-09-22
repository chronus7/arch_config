#!/bin/bash
base="https://raw.githubusercontent.com/DaveAtGit/arch_config/master/vm/"
curl "${base}arch_init.sh" > arch_init.sh
curl "${base}arch_init_chroot.sh" > arch_init_chroot.sh
chmod u+x arch_init{,_chroot}.sh
./arch_init.sh
