#!/bin/bash

update_wp (){
    current=$1
    url=$2
    # create tmp dir and download latest version
    mkdir tmp
    curl -O https://wordpress.org/latest.tar.gz
    tar -zxf latest.tar.gz -C tmp/

    new='tmp/wordpress'
    rm -fr $new/wp-content
    oU=`stat -c "%U" $current`
    oG=`stat -c "%G" $current`
   
    if [ -e "$current/wp-config.php" ]; then
	for f in $( ls $new ) ; do
		if [ -e "$current/$f" ]; then
			rm -fr "$current/$f"
			cp -ar "$new/$f" "$current/$f"
		fi	
	done
    else
 	echo -e "This is not a wordpress directory"
    fi

    rm -fr tmp latest.tar.gz
    chown -R $oU:$oG $current

    if [ -e /usr/bin/links ]; then
	links -dump "http://$url/wp-admin/upgrade.php?step=1&backto=%2Fwp-admin%2F"
    fi
	
}
if [ -z $1 && -z $2 ]; then
	echo -e "$0 /blog/root/dir fqdn \n"
	exit
else
	update_wp $1 $2
fi
