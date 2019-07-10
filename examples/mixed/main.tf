provider "openstack" {
  cloud = terraform.workspace
}

###########################
# Security groups examples
###########################
module "vrrp_self_rules_sg" {
  source = "../.."

  name        = "vrrp-rules-sg"
  description = "Security group with VRRP communication for all within the same group over IPv4+IPv6"

  default_remote_group_id = "@self"

  rules = [
    # All possible fields:
    # {
    #   direction = "ingress"
    #   protocol = "tcp"
    #   ethertype = "IPv4"
    #   port_range_min = 8080 --> if "port" is defined then it overrides this value
    #   port_range_max = 8081 --> if "port" is defined then it overrides this value
    #   port = 80
    #   remote_ip_prefix = "0.0.0.0/0"
    #   remote_group_id = "@self"
    #   description = "HTTP"
    # },
    {
      description = "VRRP"
      direction   = "ingress"
      protocol    = "vrrp"
    },
  ]
}


module "http_server_ingress_rules_sg" {
  source = "../.."

  name        = "http-server-ingress-rules-sg"
  description = "Security group with HTTP and HTTPS ports open for everybody (IPv4+IPv6 CIDR)"

  default_ipv4_remote_ip_prefix = "0.0.0.0/0"
  default_ipv6_remote_ip_prefix = "::/0"

  ingress_rules = [
    {
      description = "HTTP"
      protocol    = "tcp"
      port        = 80
    },
    {
      description = "HTTPS"
      protocol    = "tcp"
      port        = 443
    },
  ]
}


module "ssh_ingress_rules_ipv4_ipv6_sg" {
  source = "../.."

  name        = "ssh-ingress-rules-ipv4-ipv6-sg"
  description = "Security group with SSH port open for any where IPv4 and IPv6 is defined separately"

  tags = ["access"]

  ingress_rules_ipv4 = [
    {
      description      = "SSH"
      protocol         = "tcp"
      port             = 22
      remote_ip_prefix = "0.0.0.0/0"
    },
  ]

  ingress_rules_ipv6 = [
    {
      description      = "SSH"
      protocol         = "tcp"
      port             = 22
      remote_ip_prefix = "::/0"
    },
  ]

}


module "http_server_egress_rules_sg" {
  source = "../.."

  name        = "icmp-egress-rules-sg"
  description = "Security group allowing outbound ICMP traffic to any (IPv4+IPv6 CIDR)"

  default_ipv4_remote_ip_prefix = "0.0.0.0/0"
  default_ipv6_remote_ip_prefix = "::/0"

  egress_rules = [
    {
      description = "ICMP (Ping)"
      protocol    = "icmp"
    },
  ]
}


module "icmp_egress_rules_ipv4_ipv6_sg" {
  source = "../.."

  name        = "icmp-egress-rules-ipv4-ipv6-sg"
  description = "Security group with ICMP allowed to any for IPv6 but limited for IPv4"

  default_ipv6_remote_ip_prefix = "::/0"

  egress_rules_ipv4 = [
    {
      description      = "ICMP (Ping)"
      protocol         = "icmp"
      remote_ip_prefix = "192.168.1.0/28"
    },
  ]

  egress_rules_ipv6 = [
    {
      description = "ICMP (Ping)"
      protocol    = "icmp"
    },
  ]
}

