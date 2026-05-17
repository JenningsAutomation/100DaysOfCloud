![placeholder image](Images\AWS_arch.png)

# Hybrid Cloud AWS Deployment

## Introduction

✍️ In hybrid networking architectures, organizations often need to securely connect their on-premises networks to cloud environments to enable seamless communication between resources hosted in both locations. A common approach is establishing a site-to-site VPN between an on-premises network and an AWS Virtual Private Cloud (VPC). This type of connection allows organizations to extend their internal networks into the cloud, supporting scenarios such as hybrid deployments, remote branch connectivity, and secure workload integration.

## Prerequisite

✍️ I'll be using an Azure VM that has a preinstalled GNS3 virtual environment to simulate the on-premises network that will connect to AWS. 


## Cloud Research

- ✍️ Based off a tutorial from QA

### Step 1 — Setup on-prem environment (GNS3)
In this step, we will setup the GNS3 environment. We will launch GNS3 and then enabled the Hyper-V hosted GNS3 VM option. We will confirm connectivity was successful (green indicators). 


### Step 1 — Open GNS3 and create a project

![Screenshot](Images\GNS3_project.png)

### Step 2 — Open Edit -> Preferences -> GNS3 VM to configure the GNS3 VM:

![Screenshot](Images\GNS3_preferences.png)
#### Click Enable the GNS3 VM option:
- Increase the RAM to 24576 (24GB)
- Click OK (all remaining options remain as is)

### Step 3 — Create AWS Customer Gateway
Switch over to the AWS console. In the search bar, Search for Customer Gateways

### Step 4 — Click Create Customer Gateway
- Set Name Tag
- Set BGP ASN to 65000 (default)
- Set IP Address to the on-prem network (GNS3)
- Create Gateway

### Step 5 — Create AWS Virtual Private Gateway
In search bar search for Virtual private gateways and click create virtual private gateway
- Set Name tag
- Set Autonomous System Number (ASN) to Amazon default ASN
- Create virtual private gateway
- In the Virtual private gateways list, right-click on virtual-private-gateway-01 and select Actions -> Attach to VPC
- In Available VPCs, select the VPC named VPC-Onprem
- Click Attach to VPC
- Confirm that the VPC attachment state for the virtual-private-gateway-01 is Attached

### Step 6 — Setup Route Tables
In the left hand menu click Route Tables
- select RouteTable-Onprem option
- select the routes tab
- Edit routes
- Add Route
- Set Destination. This is the IP of the static route of the on-prem network modelled within GNS3
- Set Target to Virtual Private Gateway, and then select the virtual-private-gateway-01 option
- save changes

### Step 7 — Create AWS Site-to-Site VPN Connection
- Search for Site-to-Site VPN. Click on the Site-to-Site VPN connections search result
- Click Create VPN connection
- Set Name tag 
- Set Target gateway type to Virtual private gateway
- Set Virtual private gateway to virtual-private-gateway-01
- Set Customer gateway to Existing (default)
- Set Customer gateway ID to customer-gateway-01
- Set Routing options to Static
- Set Static IP prefixes to 192.168.200.0/24.Note: This is the on-prem network to be modelled within GNS3
- Set Pre-shared key storage to Standard
- Tunnel 1 Options -> Set Inside IPv4 CIDR for tunnel 1 to 169.254.100.1/30 (?)
- Tunnel 1 Options -> Set Pre-shared key for tunnel 1 to sup3rsecr3t_psk
- Tunnel 1 Options -> Set Advanced options for tunnel 1 to Edit tunnel 1 options
- Tunnel 1 Options -> Set Phase 1 encryption algorithms to AES256
- Tunnel 1 Options -> Set Phase 2 encryption algorithms to AES256
- Tunnel 1 Options -> Set Phase 1 integrity algorithms to SHA2-256
- Tunnel 1 Options -> Set Phase 2 integrity algorithms to SHA2-256
- Tunnel 1 Options -> Set Phase 1 DH group numbers to 14
- Tunnel 1 Options -> Set Phase 2 DH group numbers to 14
- Tunnel 1 Options -> Set IKE Version to ikev2
- Tunnel 1 Options -> Set Phase 1 lifetime (seconds) to 27000
- Tunnel 2 Options -> Set Inside IPv4 CIDR for tunnel 2 to 169.254.200.1/30 (?)
- Tunnel 2 Options -> Set Pre-shared key for tunnel 2 to sup3rsecr3t_psk
- Tunnel 2 Options -> Set Advanced options for tunnel 2 to Edit tunnel 2 options
- Tunnel 2 Options -> Set Phase 1 encryption algorithms to AES256
- Tunnel 2 Options -> Set Phase 2 encryption algorithms to AES256
- Tunnel 2 Options -> Set Phase 1 integrity algorithms to SHA2-256
- Tunnel 2 Options -> Set Phase 2 integrity algorithms to SHA2-256
- Tunnel 2 Options -> Set Phase 1 DH group numbers to 14
- Tunnel 2 Options -> Set Phase 2 DH group numbers to 14
- Tunnel 2 Options -> Set IKE Version to ikev2
- Tunnel 2 Options -> Set Phase 1 lifetime (seconds) to 27000

##### Create VPN connection

### Step 8 — Confirm VPN connection in VM powershell
```
    $env:AWS_ACCESS_KEY_ID = "ABCDEFGHJKLMNOPQRSTUVWXYZ" (This will change)
    $env:AWS_SECRET_ACCESS_KEY = "01234567890#######/####" (This will change)
    $env:AWS_REGION = "us-west-2"
```
There should be a vpn-config.ps1 file in the lab folder
![Screenshot](Images\vm_psh_command.png)

### Step 9 — Execute powershell config script
```
    cd C:\Users\student\lab
    .\vpn-config.ps1 virtual-private-gateway-01 sup3rsecr3t_psk
```

![Screenshot](Images\ps1_result.png)

### Step 10 — Navigate to student\lab folder
Using File Explorer, navigate to the C:\Users\student\lab folder. Confirm that a new file named vpn-config.txt has been created.

### Step 11 — Building GNS3 On-Prem Network Configuration
- Return to the GNS3 modeling application
- Click on the Browse all devices icon
- Drag and drop a Cloud node onto the workspace. This device represents the Internet
- In the Server popup select GNS3 VM as the host
- Drag and drop a VyOS device onto the current workspace. This device acts as a layer-3 router and firewall
- Drag and drop a VPCS device onto the current workspace. This device represents an on-premises PC
- In the Server popup select GNS3 VM as the host
- Confirm the Servers Summary config is the same as the following.Note: Both the VyOS-1 and PC1 devices are expected to be in a stopped status (you will start them shortly)
- Click on the Add a link button in the toolbar.This will be used to configure ethernet links between each devices on the workspace
- Connect the VyOS and Cloud devices together. Click the VyOS device and select it's eth0 interface. Complete the link by clicking on the Cloud device, and then selecting it's eth0 interface
- Connect the VyOS and VPCS devices together. Click the VyOS device and select it's eth1 interface. Complete the link by clicking on the VPCS device, and then selecting it's eth0 interface
- Start the VyOS device. Right-click over the top of it and select Start
- Double-click the VyOS device to launch a console (terminal)
- Confirm that the VyOS device boots up successfully
- Login to VyOS with the following credentials:
    ```
        Username: vyos
        Password: vyos 
    ```
- Enter configuration mode, type conf and enter
- Apply the following interface configuration:
    ```
    set interfaces ethernet eth0 address 192.168.100.200/24
    set interfaces ethernet eth1 address 192.168.200.200/24
    set protocols static route 0.0.0.0/0 next-hop 192.168.100.1
    commit
    ```
### Step 12 — Test Internet connectivity
``` ping -c5 8.8.8.8 ```

### Step 13 — Apply the following NAT configuration  
    
    set nat source rule 100 outbound-interface name eth0
    set nat source rule 100 source address 192.168.200.0/24
    set nat source rule 100 translation address masquerade
    commit     
    
### Step 14 — Apply the DNS Configuration    
    
    set system name-server 8.8.8.8
    set system name-server 8.8.4.4
    commit
    
    
Note: This provides DNS resolution for the VyOS device itself.

### Step 15 — Test DNS resolution:
```ping -c5 www.google.com```

### Step 16 — Apply the DNS configuration    
    set service dns forwarding name-server 8.8.8.8
    set service dns forwarding name-server 8.8.4.4
    set service dns forwarding allow-from 192.168.200.0/24
    set service dns forwarding listen-address 192.168.200.200
    commit
    
Note: This provides DNS resolution for the internal network.

### Step 17 — save
```save```

### Step 18 — Start the VPCS device
- Start the VPCS device (on-premises PC device). Right-click over the top of it and select Start
- Double-click the VPCS device to launch a console (terminal)
- Confirm that the VPCS device has booted up successfully

### Step 19 — Configure the VPCS device
Configure the following static IP addressing scheme on the VPCS device:
```ip 192.168.200.100 255.255.255.0 192.168.200.200```

### Step 20 — Confirm Internet connectivity 
Confirm that the on-premises PC device has Internet connectivity (via the VyOS router):
```ping 8.8.8.8```

### Step 21 — Configure the following DNS configuration on the VPCS device
```ip dns 192.168.200.200```

### Step 22 — Test DNS resolution:
```ping www.google.com```

### Step 23 — Leave the VPCS terminal open.

### Step 24 — save
```save```

### Step 25 — VyOS Site-to-Site VPN Configuration
Configure and validate a site-to-site VPN tunnel on the VyOS router. The process begins by applying the pre-prepared VPN IPsec tunnel commands from the generated vpn-config.txt file to the VyOS device. Having applied the IPsec configuration, verify the VPN status. This includes checking the IKE security associations (Phase 1) that establish secure key exchange, the IPsec security associations (Phase 2) that protect data traffic, and the overall IPsec connection parameters. The goal is to confirm that both VPN tunnels from on-premises to AWS are in an UP state, ensuring secure communication across the hybrid network has been established.

### Step 26 — Configure VPN Tunnel
apply the VPN IPsec tunnel configuration. Return to the C:\Users\student\lab\vpn-config.txt file and copy its entire contents (all commands).

![Screenshot](Images\vpn-config.txt.png)
### Step 27 — Return to the VyOS console and paste all VPN IPsec tunnel commands
```
commit
save
exit
```
### Step 28 — Examine and display the current IKE security associations (SAs)
These are the Phase 1 tunnels that negotiate keys and policies before the IPsec (Phase 2) tunnels are created. In particular, confirm that they are in an UP status

```show vpn ike sa``
![Screenshot](Images\IKE_sa.png)

### Step 29 — Examine and display the current IPsec security associations (SAs)
These are the Phase 2 tunnels that negotiate the actual data-protecting tunnels. In particular, confirm that they are in an UP status

```show vpn ipsec sa```
![Screenshot](Images\ipsec_sa.png)
### Step 30 — Examine and display the configured IPsec connections and their parameters. 
In particular, confirm that they are in an UP status

```show vpn ipsec connections```
![Screenshot](Images\ipsec_connections.png)
### Step 31 — Return to the AWS Site-to-Site VPN console to view the VPN tunnel status


![Screenshot](Images\vpn_tunnel_details.png)

### Step 32 — Select vpn-01, and view the Tunnel details tab. Confirm that the tunnels are Up:

Summary

In this step, the site-to-site VPN configuration is applied and verified of its operation. Both Phase 1 (IKE) and Phase 2 (IPsec) tunnels were confirmed to be UP, ensuring that secure communication between sites is established. Additionally, the cloud on-prem route table were updated to route 192.168.200.0/24 traffic via the virtual private gateway.

### Step 33 — Hybrid Network VPN End-to-End Testing
In this step, end-to-end testing of the hybrid network VPN connection established between the on-premises network (GNS3 VPCS) and the cloud-hosted VM (ca-lab-vm-cloud-test). Private traffic is confirmed to be routed successfully between the on-premises network 192.168.200.0/24 and the cloud-hosted network 10.2.0.0/16. the following two traffic flow tests are performed:

    Ping Test 1: On-premises to Cloud
    Ping Test 2: Cloud to On-premises

The following are completed in GNS3 on the remote desktop.
Ping Test 1: On-premises to Cloud

- Return to the VPCS device console within the GNS3 modeling application
- Ping the cloud-hosted test VM's (ca-lab-vm-cloud-test) private IP address:
```ping 10.2.0.173```
- Confirm valid ICMP responses are returned from the cloud-hosted test VM (ca-lab-vm-cloud-test).
- Successful ICMP responses imply on-premises to cloud initiated network traffic is correctly being routed across the VPN.
![Screenshot](Images\on-prem-cloud-verification.png)

#### Ping Test 2: Cloud to On-premises

### Step 34 — Return to the AWS console. Search for EC2. Click on the EC2 search result
-  Click on Instances (running)
- Connect to the instance
- ```ping -c5 192.168.200.100```

![Screenshot](Images\cloud-to-on-prem-verification.png)

## ☁️ Cloud Outcome

✍️ In this session I built a realistic hybrid networking scenario in which the GNS3-modeled on-premises network, securely connects to AWS resources, allowing full bi-directional communication while maintaining isolation of internal subnets. I successfully connected to a Azure VM using RDP. The Azure VM had GNS3 pre-installed, which I used to design and configure the hybrid network topology. 
In the GNS3 environment I enabled the Hyper-V hosted GNS3 VM option. This made the GNS3 application ready to host a hybrid network setup. I then created a Customer Gateway. The Customer Gateway represents the on-premises VPN device. The on-premises VPN device is modeled within GNS3, therefore the Customer Gateway is configured with the remote desktop's public IP address. I then created a Virtual Private Gateway and attached it to the on-prem VPC. The Virtual Private Gateway represents the AWS cloud-side VPN device. I then configured a new Site-to-Site VPN connection. I moved on and begin the on-premises network configuration inside GNS3. In particular,the VyOS (layer-3 router), to terminate the Site-to-Site VPN connection on the on-premises side. I configured the  VyOS router to connect an internal LAN to the Internet using static routes, NAT, and DNS. I also set up a VPCS device (on-premises PC) with a static IP and DNS, and then verified end-to-end Internet connectivity through the VyOS router. Next I applied the site-to-site VPN configuration and verified its operation. Both Phase 1 (IKE) and Phase 2 (IPsec) tunnels were confirmed to be UP, ensuring that secure communication between sites is established. Additionally, I updated the cloud on-prem route table to route 192.168.200.0/24 traffic via the virtual private gateway. In this step, I verified end-to-end connectivity across the hybrid network utilizing the IPsec VPN for secured communications. You confirmed that private network traffic routed successfully between the on-premises network 192.168.200.0/24 and the cloud-hosted network 10.2.0.0/16. This validated that the VPN configuration is functioning correctly.

## Next Steps

✍️ Next step is to repeat the exact same thing except this time use terraform or some other Infrastructure as Code

## Social Proof

✍️ Show that you shared your process on Twitter or LinkedIn

[Mastodon](https://mastodon.social/@code_sentinel/116592222190061704)
[LinkedIn](https://www.linkedin.com/posts/demian-jennings_100daysofcloud-share-7461904190169047040-Poer?utm_source=share&utm_medium=member_desktop&rcm=ACoAADXbhxEBzxsfNpRcEjDWcxJMI75kD_O-eRA)