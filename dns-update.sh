#!/bin/sh

if [ "$#" -lt "3" ] ; then
    echo "usage: $0 username password id" >&2
    echo "Update DNSMadeEasy dynamic record having the id id" >&2
    echo "Username is the login id on DNSMadeEasy and password is its password or the" >&2
    echo "record specific one if set" >&2
    echo "Options set from the enviroment:" >&2
    echo "IP=ip to set to (default: same as 'curl https://checkip.amazonaws.com')" >&2
    echo "DOMAIN=domain name (default: same as hostname -d)"
    echo "HOST=hostname short form (default: same as hostname -c)"
    exit 1
fi
username="$1"
pw="$2"
id="$3"
DOMAIN=${DOMAIN-`hostname -d`}
HOST=${HOST-`hostname -s`}
IP=${IP-`curl -s https://checkip.amazonaws.com`}

output=`curl -s "https://cp.dnsmadeeasy.com/servlet/updateip?username=$username@$domain&password=$pw&id=$id&ip=$IP"`
ret=$?
if [ "$ret" != "0" ] ; then
    echo "failed: curl return value $ret" >&2
    echo "output: $output" >&2
    exit $ret
fi
if [ "$output" != "success" ] ; then
    echo "failed: updating returns non-success" >&2
    echo "output: $output" >&2
    exit 255
fi
