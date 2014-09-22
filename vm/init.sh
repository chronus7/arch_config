#!/bin/bash
base="https://raw.githubusercontent.com/DaveAtGit/arch_config/master/vm/"
curl -o "arch_init#1.sh" "${base}arch_init{,_chroot}.sh"
chmod u+x arch_init{,_chroot}.sh
./arch_init.sh
