#!/bin/bash

# Update and install StrongSwan
echo "Updating system packages..."
sudo apt-get update -y
echo "Installing StrongSwan..."
sudo apt-get install -y strongswan

# Enable IP forwarding
echo "Enabling IP forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1

# Make IP forwarding persistent across reboots
echo "Making IP forwarding persistent..."
sudo sed -i '/^#net.ipv4.ip_forward=1/s/^#//g' /etc/sysctl.conf
sudo sysctl -p

# Configure StrongSwan (ipsec.conf)
echo "Configuring ipsec.conf..."
sudo bash -c 'cat > /etc/ipsec.conf <<EOF
# ipsec.conf - StrongSwan VPN Configuration

config setup
    # General settings for StrongSwan
    charon.loglevel=2

conn %default
    keyexchange=ikev2
    ikelifetime=60m
    keylife=20m
    rekeymargin=3m
    keyingtries=1
    authby=secret
    auto=start

conn myvpn
    left=192.168.1.10        # VPN server IP (replace with actual)
    leftid=@vpn-server       # Server identity
    leftsubnet=0.0.0.0/0     # Subnet accessible via VPN
    leftauth=psk
    right=%any               # Allow clients from any IP
    rightdns=8.8.8.8         # DNS for clients
    rightsourceip=10.10.10.0/24  # VPN client IP range
    rightauth=psk
    esp=aes256-sha2_256      # Encryption and integrity algorithms
EOF'

# Configure Pre-Shared Key (PSK)
echo "Configuring ipsec.secrets..."
sudo bash -c 'cat > /etc/ipsec.secrets <<EOF
# ipsec.secrets - StrongSwan PSK Configuration

# Pre-shared key for authentication (Replace with your own secure key)
@vpn-server : PSK "your-secure-psk-here"
EOF'

# Restart StrongSwan to apply the changes
echo "Restarting StrongSwan service..."
sudo systemctl restart strongswan

# Enable StrongSwan service on boot
echo "Enabling StrongSwan service on boot..."
sudo systemctl enable strongswan

# Verify StrongSwan status
echo "Verifying StrongSwan service status..."
sudo systemctl status strongswan

# Display VPN Server status and configuration
echo "VPN Server setup complete! Here is the status:"
sudo ipsec statusall

# Explanations/Comments Below

# The script begins by updating the system's package list and installing the StrongSwan VPN package.
# StrongSwan is a VPN software that supports the IPsec protocol and is widely used for secure communication.

# Enabling IP forwarding allows the VPN server to route traffic between different network interfaces,
# ensuring that VPN clients can communicate with other systems through the VPN tunnel.

# To make IP forwarding persistent, we modify the sysctl.conf file and reload the configuration.
# This ensures that the setting is applied even after system reboots.

# The ipsec.conf file is configured with default settings that define the VPN's security protocols,
# key exchange mechanisms, and server/client configurations. Here, the key exchange is IKEv2,
# which is secure and efficient for VPN setups. The left side represents the server, and the right side represents clients.

# The ipsec.secrets file holds the pre-shared key (PSK) used for authentication.
# This key should be replaced with a strong, secure key for actual use.

# After the configuration, StrongSwan is restarted to apply the changes. The system is also configured to start
# StrongSwan automatically on boot, ensuring the VPN server is always active.

# Finally, the script checks the status of the StrongSwan service and displays the VPN server's configuration
# and status using the 'ipsec statusall' command, which helps verify that everything is working as expected.
