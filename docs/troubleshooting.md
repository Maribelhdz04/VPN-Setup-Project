# Troubleshooting

## Problem: VPN Connection Fails
- **Possible Causes**:
  - Incorrect IPsec configuration (e.g., wrong pre-shared key or certificates).
  - Firewall blocking VPN ports (UDP 500, UDP 4500, ESP).
- **Solution**:
  1. Verify your IPsec configuration (`ipsec.conf` and `ipsec.secrets`).
  2. Ensure that firewall rules are correctly set to allow traffic on the VPN ports:
     ```bash
     sudo ufw allow 500,4500/udp
     sudo ufw allow esp
     ```
  
## Problem: Slow VPN Speed
- **Possible Causes**:
  - Network congestion or insufficient bandwidth.
  - Encryption overhead.
- **Solution**:
  1. Check the network connection and ensure sufficient bandwidth.
  2. Consider using faster encryption algorithms (e.g., AES-GCM).

## Problem: IPsec Service Not Starting
- **Possible Causes**:
  - Incorrect installation or missing dependencies.
- **Solution**:
  1. Ensure StrongSwan is installed properly:
     ```bash
     sudo apt install strongswan
     ```
  2. Check service status:
     ```bash
     sudo systemctl status strongswan
     ```
