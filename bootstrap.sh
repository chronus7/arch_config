#!/bin/bash
#-- Script to link given config-files to their respective
#   places. This might call for sudo, sometimes.
#	The seperator for links is ';'!

while read line
do
		IFS=';'
		arr=($line)
		${arr[2]} ln -sf "${arr[0]/\~/$HOME}" "${arr[1]/\~/$HOME}"
done < ~/arch_config/links
