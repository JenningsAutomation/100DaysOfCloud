output "vyos_vpn_config_commands" {
  value = <<EOT
Run these commands inside your GNS3 VyOS router terminal to configure BOTH tunnels:

# 1. Base IPsec Crypto Profiles
set vpn ipsec ike-group AWS-IKE proposal 1 encryption aes256
set vpn ipsec ike-group AWS-IKE proposal 1 hash sha256
set vpn ipsec ike-group AWS-IKE proposal 1 dh-group 14
set vpn ipsec ike-group AWS-IKE lifetime 27000

set vpn ipsec esp-group AWS-ESP proposal 1 encryption aes256
set vpn ipsec esp-group AWS-ESP proposal 1 hash sha256
set vpn ipsec esp-group AWS-ESP proposal 1 dh-group 14

# 2. Tunnel 1 Interface & Peer Definition (vti0)
set interfaces vti vti0 address ${cidrhost(aws_vpn_connection.hybrid_vpn.tunnel1_inside_cidr, 2)}/30
set vpn ipsec site-to-site peer ${aws_vpn_connection.hybrid_vpn.tunnel1_address} authentication mode pre-shared-secret
set vpn ipsec site-to-site peer ${aws_vpn_connection.hybrid_vpn.tunnel1_address} authentication pre-shared-secret sup3rsecr3t_psk
set vpn ipsec site-to-site peer ${aws_vpn_connection.hybrid_vpn.tunnel1_address} ike-group AWS-IKE
set vpn ipsec site-to-site peer ${aws_vpn_connection.hybrid_vpn.tunnel1_address} vti bind vti0
set vpn ipsec site-to-site peer ${aws_vpn_connection.hybrid_vpn.tunnel1_address} vti esp-group AWS-ESP

# 3. Tunnel 2 Interface & Peer Definition (vti1)
set interfaces vti vti1 address ${cidrhost(aws_vpn_connection.hybrid_vpn.tunnel2_inside_cidr, 2)}/30
set vpn ipsec site-to-site peer ${aws_vpn_connection.hybrid_vpn.tunnel2_address} authentication mode pre-shared-secret
set vpn ipsec site-to-site peer ${aws_vpn_connection.hybrid_vpn.tunnel2_address} authentication pre-shared-secret sup3rsecr3t_psk
set vpn ipsec site-to-site peer ${aws_vpn_connection.hybrid_vpn.tunnel2_address} ike-group AWS-IKE
set vpn ipsec site-to-site peer ${aws_vpn_connection.hybrid_vpn.tunnel2_address} vti bind vti1
set vpn ipsec site-to-site peer ${aws_vpn_connection.hybrid_vpn.tunnel2_address} vti esp-group AWS-ESP
EOT
  description = "Dynamic dual-tunnel configuration configuration for GNS3 VyOS"
}