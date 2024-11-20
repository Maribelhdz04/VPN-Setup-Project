StrongSwan IPsec VPN Project

Overview

This project demonstrates the setup of a secure IPsec VPN using StrongSwan, a robust open-source software suite for IPsec-based VPNs. The goal is to establish secure communication over an untrusted network (such as the internet), ensuring data privacy and security.

By implementing this solution, users can better understand how to configure and test a StrongSwan-based VPN for secure communications in real-world applications.

Motivation

In today’s connected world, secure communication is more critical than ever. VPNs (Virtual Private Networks) are a key solution in providing:

Business Communication: Secure access for remote employees or teams.
Personal Privacy: Protecting sensitive data during internet usage, especially on public networks.
Enhanced Security: Safeguarding transmitted data against interception, tampering, or unauthorized access.
This project simulates such a setup and explains how to configure and test a StrongSwan-based IPsec VPN to secure communication across an untrusted network.

Network Topology

This project implements a simple client-server VPN model:

[Client VM] <---> [VPN Server VM (StrongSwan)] <---> [External Network]
VPN Server: Hosts the StrongSwan service and authenticates clients.
VPN Client: Connects to the server and routes traffic through the secure VPN tunnel.
Prerequisites

Before starting the setup, ensure the following prerequisites are met:

Operating System: Ubuntu 20.04 or later (server and client).
Software: StrongSwan, iptables, tcpdump.
Optional: VirtualBox/VMware for creating virtual environments.
Installation

Install StrongSwan
To begin, install StrongSwan on both the server and client systems:

sudo apt update
sudo apt install -y strongswan strongswan-pki
VPN Server Configuration

Generate Certificates
The first step in configuring the VPN server is to generate the necessary certificates:

mkdir -p ~/pki/{cacerts,certs,private}
chmod 700 ~/pki
ipsec pki --gen --outform pem > ~/pki/private/ca.key.pem
ipsec pki --self --ca --lifetime 3650 \
  --in ~/pki/private/ca.key.pem \
  --dn "C=US, O=My VPN, CN=MyVPN CA" \
  --outform pem > ~/pki/cacerts/ca.cert.pem
Configure IPsec
Edit the StrongSwan configuration file (ipsec.conf) to define the connection settings:

sudo nano /etc/ipsec.conf
Add the following configuration for the VPN:

conn myvpn
    authby=secret
    auto=add
    left=%any
    leftid=@vpnserver
    leftsubnet=10.0.0.0/24
    right=%any
    rightsourceip=10.0.1.0/24
    rightauth=psk
Client Configuration

To configure the client, you’ll need to update the client’s ipsec.conf file with the VPN server’s details and then establish the connection:

sudo ipsec up myvpn
Expected Outputs

1. VPN Server Status
To verify that the VPN server is running and the connection is established, use the following command to check the server status:

sudo ipsec status
Expected Output:

Security Associations (1 up, 0 connecting):
    myvpn[1]: ESTABLISHED 20 seconds ago, 192.168.1.1[server]...192.168.1.2[client]
2. Traffic Test
Ping the server from the client to verify the VPN connection:

ping -c 4 <Server-IP>
Capture the encrypted traffic on the server using tcpdump:

sudo tcpdump -i eth0 esp
Expected Output: Screenshot showing ESP packets.

Files in This Repository

Folder	Contents
configs/	Configuration files (e.g., ipsec.conf).
docs/	Documentation and diagrams.
simulated_outputs/	Simulated command outputs and screenshots.
scripts/	Automation scripts (e.g., setup_vpn.sh).
screenshots/	Visuals for server setup and testing.
Simulated Outputs

You can find all simulated command outputs and visuals in the simulated_outputs/ and screenshots/ directories.

Screenshots :
    StrongSwan Installation
    IPsec Status
    Ping Test (shows the successful ping test between the server and client over the VPN tunnel)

Citations:
Cisco. "Introduction to IPsec and VPNs."
StrongSwan Wiki. "Getting Started with StrongSwan."
