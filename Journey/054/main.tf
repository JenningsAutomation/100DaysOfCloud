# 1. Define the Cloud VPC
resource "aws_vpc" "cloud_vpc" {
  cidr_block           = "10.2.0.0/16"
  enable_dns_hostnames = true

  tags = { Name = "VPC-Cloud" }
}

# 2. Define the Cloud Private Subnet (where your test EC2 instance lives)
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.cloud_vpc.id
  cidr_block        = "10.2.0.0/24"
  availability_zone = "us-west-2a"

  tags = { Name = "Subnet-Cloud-Private" }
}

# 3. Customer Gateway (Points to your GNS3 Public IP)
resource "aws_customer_gateway" "onprem_cgw" {
  bgp_asn    = 65000
  ip_address = "20.225.74.214" # Replace with your GNS3 VM public IP
  type       = "ipsec.1"

  tags = { Name = "customer-gateway-01" }
}

# 4. Virtual Private Gateway (Attached to AWS VPC)
resource "aws_vpn_gateway" "cloud_vgw" {
  vpc_id = aws_vpc.cloud_vpc.id

  tags = { Name = "virtual-private-gateway-01" }
}

# 5. Site-to-Site VPN Connection with your exact custom encryption requirements
resource "aws_vpn_connection" "hybrid_vpn" {
  vpn_gateway_id      = aws_vpn_gateway.cloud_vgw.id
  customer_gateway_id = aws_customer_gateway.onprem_cgw.id
  type                = "ipsec.1"
  static_routes_only  = true

  # Tunnel 1 Custom Security Options (Matching Day 53)
  tunnel1_ike_versions                 = ["ikev2"]
  tunnel1_phase1_encryption_algorithms = ["AES256"]
  tunnel1_phase2_encryption_algorithms = ["AES256"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-256"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-256"]
  tunnel1_phase1_dh_group_numbers      = [14]
  tunnel1_phase2_dh_group_numbers      = [14]
  tunnel1_preshared_key                = "sup3rsecr3t_psk"

  tags = { Name = "vpn-connection-01" }
}

# 6. Route On-Prem Traffic (192.168.200.0/24) through the VPN Gateway
resource "aws_route_table" "cloud_rt" {
  vpc_id = aws_vpc.cloud_vpc.id

  route {
    cidr_block = "192.168.200.0/24"
    gateway_id = aws_vpn_gateway.cloud_vgw.id
  }

  tags = { Name = "RouteTable-Cloud" }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.cloud_rt.id
}
