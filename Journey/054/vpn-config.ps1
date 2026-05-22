param (
    [Parameter(Mandatory = $true)]
    [string]$VPG_NAME,

    [Parameter(Mandatory = $true)]
    [string]$PRESHARED_KEY 
)

# Get the VPN Gateway details using the Name tag
$gateway = aws ec2 describe-vpn-gateways `
    --filters "Name=tag:Name,Values=$VPG_NAME" `
    --query "VpnGateways[0]" `
    | ConvertFrom-Json

# Get the VPN Connection associated with the VGW
$vpnConnection = aws ec2 describe-vpn-connections `
    --filters "Name=vpn-gateway-id,Values=$($gateway.VpnGatewayId)" `
    --query "VpnConnections[0]" `
    | ConvertFrom-Json

# Extract the public IPs for Tunnel 1 and Tunnel 2
$VGW_PUBLIC_IP1 = $vpnConnection.Options.TunnelOptions[0].OutsideIpAddress
$VGW_PUBLIC_IP2 = $vpnConnection.Options.TunnelOptions[1].OutsideIpAddress

# Display the IP addresses
Write-Host "Tunnel 1 Public IP: $VGW_PUBLIC_IP1"
Write-Host "Tunnel 2 Public IP: $VGW_PUBLIC_IP2"

# Build the configuration content
$config = @"
# IKE + ESP ===========

# IKE Group (Phase 1)
set vpn ipsec ike-group IKE-GROUP dead-peer-detection action 'restart'
set vpn ipsec ike-group IKE-GROUP dead-peer-detection interval '10'
set vpn ipsec ike-group IKE-GROUP dead-peer-detection timeout '30'
set vpn ipsec ike-group IKE-GROUP key-exchange 'ikev2'
set vpn ipsec ike-group IKE-GROUP lifetime '28800'
set vpn ipsec ike-group IKE-GROUP proposal 1 dh-group '14'
set vpn ipsec ike-group IKE-GROUP proposal 1 encryption 'aes256'
set vpn ipsec ike-group IKE-GROUP proposal 1 hash 'sha256'

# ESP Group (Phase 2)
set vpn ipsec esp-group ESP-GROUP proposal 1 encryption 'aes256'
set vpn ipsec esp-group ESP-GROUP proposal 1 hash 'sha256'
set vpn ipsec esp-group ESP-GROUP pfs 'enable'
set vpn ipsec esp-group ESP-GROUP lifetime '27000'

# TUNNEL 1 ===========

set interfaces vti vti0 address '169.254.100.1/30'
set interfaces vti vti0 description 'VPG tunnel 1'
set interfaces vti vti0 ip adjust-mss 1350
set interfaces vti vti0 mtu '1436'

# cloud private network
set protocols static route 10.0.0.0/16 interface vti0
set protocols static route 10.2.0.0/16 interface vti0

set vpn ipsec authentication psk AWS-T1 id $VGW_PUBLIC_IP1
set vpn ipsec authentication psk AWS-T1 id 192.168.100.200
set vpn ipsec authentication psk AWS-T1 secret '$PRESHARED_KEY'

set vpn ipsec site-to-site peer AWS-T1 authentication mode 'pre-shared-secret'
set vpn ipsec site-to-site peer AWS-T1 connection-type 'initiate'
set vpn ipsec site-to-site peer AWS-T1 description 'ipsec'
set vpn ipsec site-to-site peer AWS-T1 ike-group IKE-GROUP
set vpn ipsec site-to-site peer AWS-T1 local-address '192.168.100.200'
set vpn ipsec site-to-site peer AWS-T1 remote-address '$VGW_PUBLIC_IP1'
set vpn ipsec site-to-site peer AWS-T1 vti bind 'vti0'
set vpn ipsec site-to-site peer AWS-T1 vti esp-group ESP-GROUP
set vpn ipsec site-to-site peer AWS-T1 force-udp-encapsulation

# TUNNEL 2 ===========

set interfaces vti vti1 address '169.254.200.1/30'
set interfaces vti vti1 description 'VPG tunnel 2'
set interfaces vti vti1 ip adjust-mss 1350
set interfaces vti vti1 mtu '1436'

# cloud private network
set protocols static route 10.0.0.0/16 interface vti1
set protocols static route 10.2.0.0/16 interface vti1

set vpn ipsec authentication psk AWS-T2 id $VGW_PUBLIC_IP2
set vpn ipsec authentication psk AWS-T2 id 192.168.100.200
set vpn ipsec authentication psk AWS-T2 secret '$PRESHARED_KEY'

set vpn ipsec site-to-site peer AWS-T2 authentication mode 'pre-shared-secret'
set vpn ipsec site-to-site peer AWS-T2 connection-type 'initiate'
set vpn ipsec site-to-site peer AWS-T2 description 'ipsec'
set vpn ipsec site-to-site peer AWS-T2 ike-group IKE-GROUP
set vpn ipsec site-to-site peer AWS-T2 local-address '192.168.100.200'
set vpn ipsec site-to-site peer AWS-T2 remote-address '$VGW_PUBLIC_IP2'
set vpn ipsec site-to-site peer AWS-T2 vti bind 'vti1'
set vpn ipsec site-to-site peer AWS-T2 vti esp-group ESP-GROUP
set vpn ipsec site-to-site peer AWS-T2 force-udp-encapsulation
"@

# Write to output file
$config | Set-Content -Path "vpn-config.txt"

Write-Host "AWS Tunnel config saved to vpn-config.txt"