#!/usr/bin/env bash

if [ $# -ne 1 ]; then
	echo "ERROR: call this script with the path to the .ovpn configuration file as first argument"
	exit 1
fi

if ! [ -f $1 ]; then
	echo "OVPN configuration file $1 not found"
	exit 1
fi

# Stop the service in case it is running
sudo systemctl stop openvpn-client@bashvpn
sudo killall openvpn

# Set up DNS servers and killswitch
source ./vpnmode_do.sh

# Copy the .ovpn configuration file to OpenVPN folder
# This is /etc/openvpn/client for openvpn PPA repository
# It's just /etc/openvpn for the openvpn client of native Ubuntu
sudo cp $1 /etc/openvpn/client/bashvpn.conf

# Enable the service
sudo systemctl enable openvpn-client@bashvpn
sudo systemctl start openvpn-client@bashvpn

echo "The OpenVPN service has been installed and should be running"

