#!/usr/bin/env bash

if [ $# -ne 1 ]; then
	echo "ERROR: call this script with the path to the .ovpn configuration file as first argument"
	exit 1
fi

if ! [ -f $1 ]; then
	echo "OVPN configuration file $1 not found"
	exit 1
fi

# Take old VPN connection down
echo "Taking down VPN tunnel...."
sudo systemctl stop openvpn-client@bashvpn
sudo killall openvpn

# Stop sytemed-resolved and NetworkManager
echo "Taking down connection and interface..."
sudo systemctl stop NetworkManager
sudo systemctl stop systemd-resolved

# Set VPN DNS servers
echo "Set up VPN DNS servers..."
source ./ini_dns.sh

# Set up killswitch
source ./iptables_killswitch.sh "$1"

# Bring connection up
echo "Bringing interface and connection back up..."
sudo systemctl restart systemd-resolved
sudo systemctl restart NetworkManager
