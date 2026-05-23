# aws_customer_gateway.onprem_cgw:
resource "aws_customer_gateway" "manual_cgw" {
    bgp_asn          = "65000"
    bgp_asn_extended = null
    certificate_arn  = null
    device_name      = null
    ip_address       = "4.151.202.78"
    tags             = {
        "Name" = "customer-gateway-01"
    }
    tags_all         = {
        "Name" = "customer-gateway-01"
    }
    type             = "ipsec.1"
}

# aws_route_table.cloud_rt:
resource "aws_route_table" "manual_rt" {
    vpc_id = aws_vpc.cloud_vpc.id
    propagating_vgws = []
    route {
    cidr_block = "192.168.200.0/24"
    gateway_id = aws_vpn_gateway.cloud_vgw.id
  }

  tags = { Name = "RouteTable-Cloud" }
}

# aws_subnet.manual_private_subnet:
resource "aws_subnet" "manual_private_subnet" {
    vpc_id            = aws_vpc.cloud_vpc.id
    assign_ipv6_address_on_creation                = false
    availability_zone                              = "us-west-2a"
    cidr_block                                     = "10.2.0.0/24"
    private_dns_hostname_type_on_launch            = "ip-name"
    tags                                           = {
        Name = "Subnet"
    }
    tags_all                                       = {
        Name = "Subnet"
    }
    
}

# aws_vpc.manual_vpc:
resource "aws_vpc" "manual_vpc" {
    cidr_block           = "10.2.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "VPC-Onprem" }
}

# aws_vpn_connection.manual_vpn:
resource "aws_vpn_connection" "manual_vpn" {
    core_network_arn                        = null
    core_network_attachment_arn             = null
    enable_acceleration                     = false
    local_ipv4_network_cidr                 = "0.0.0.0/0"
    local_ipv6_network_cidr                 = null
    outside_ip_address_type                 = "PublicIpv4"
    preshared_key_arn                       = null
    preshared_key_storage                   = "Standard"
    remote_ipv4_network_cidr                = "0.0.0.0/0"
    remote_ipv6_network_cidr                = null
    routes                                  = [
        {
            destination_cidr_block = "192.168.200.0/24"
            source                 = null
            state                  = "available"
        },
    ]
    static_routes_only                      = true
    tags= {Name = "vpn-01" }
    tags_all = {Name = "vpn-01" }
    transit_gateway_attachment_id           = null
    transit_gateway_id                      = null
    transport_transit_gateway_attachment_id = null
    tunnel1_address                         = "32.184.255.92"
    tunnel1_bgp_asn                         = null
    tunnel1_bgp_holdtime                    = 0
    tunnel1_cgw_inside_address              = "169.254.100.2"
    tunnel1_dpd_timeout_action              = "clear"
    tunnel1_dpd_timeout_seconds             = 30
    tunnel1_enable_tunnel_lifecycle_control = false
    tunnel1_ike_versions                    = [
        "ikev2",
    ]
    tunnel1_inside_cidr                     = "169.254.100.0/30"
    tunnel1_inside_ipv6_cidr                = null
    tunnel1_phase1_dh_group_numbers         = [
        14,
    ]
    tunnel1_phase1_encryption_algorithms    = [
        "AES256",
    ]
    tunnel1_phase1_integrity_algorithms     = [
        "SHA2-256",
    ]
    tunnel1_phase1_lifetime_seconds         = 27000
    tunnel1_phase2_dh_group_numbers         = [
        14,
    ]
    tunnel1_phase2_encryption_algorithms    = [
        "AES256",
    ]
    tunnel1_phase2_integrity_algorithms     = [
        "SHA2-256",
    ]
    tunnel1_phase2_lifetime_seconds         = 3600
    tunnel1_preshared_key                   = "sup3rsecr3t_psk"
    tunnel1_rekey_fuzz_percentage           = 100
    tunnel1_rekey_margin_time_seconds       = 270
    tunnel1_replay_window_size              = 1024
    tunnel1_startup_action                  = "add"
    tunnel1_vgw_inside_address              = "169.254.100.1"
    tunnel2_address                         = "44.242.37.250"
    tunnel2_bgp_asn                         = null
    tunnel2_bgp_holdtime                    = 0
    tunnel2_cgw_inside_address              = "169.254.200.2"
    tunnel2_dpd_timeout_action              = "clear"
    tunnel2_dpd_timeout_seconds             = 30
    tunnel2_enable_tunnel_lifecycle_control = false
    tunnel2_ike_versions                    = [
        "ikev2",
    ]
    tunnel2_inside_cidr                     = "169.254.200.0/30"
    tunnel2_inside_ipv6_cidr                = null
    tunnel2_phase1_dh_group_numbers         = [
        14,
    ]
    tunnel2_phase1_encryption_algorithms    = [
        "AES256",
    ]
    tunnel2_phase1_integrity_algorithms     = [
        "SHA2-256",
    ]
    tunnel2_phase1_lifetime_seconds         = 27000
    tunnel2_phase2_dh_group_numbers         = [
        14,
    ]
    tunnel2_phase2_encryption_algorithms    = [
        "AES256",
    ]
    tunnel2_phase2_integrity_algorithms     = [
        "SHA2-256",
    ]
    tunnel2_phase2_lifetime_seconds         = 3600
    tunnel2_preshared_key                   = sup3rsecr3t_psk
    tunnel2_rekey_fuzz_percentage           = 100
    tunnel2_rekey_margin_time_seconds       = 270
    tunnel2_replay_window_size              = 1024
    tunnel2_startup_action                  = "add"
    tunnel2_vgw_inside_address              = "169.254.200.1"
    tunnel_inside_ip_version                = "ipv4"
    type                                    = "ipsec.1"
    vgw_telemetry                           = [

    ]

    tunnel1_log_options {
        cloudwatch_log_options {
            log_enabled       = false
            log_group_arn     = null
            log_output_format = null
        }
    }

    tunnel2_log_options {
        cloudwatch_log_options {
            log_enabled       = false
            log_group_arn     = null
            log_output_format = null
        }
    }
}

# aws_vpn_gateway.manual_vgw:
resource "aws_vpn_gateway" "manual_vgw" {

    tags            = {
        "Name" = "virtual-private-gateway-01"
    }
    tags_all        = {
        "Name" = "virtual-private-gateway-01"
    }

}