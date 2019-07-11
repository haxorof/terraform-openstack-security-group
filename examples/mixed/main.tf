provider "openstack" {
  cloud = terraform.workspace
}

###########################
# Security groups examples
###########################
module "raw_rules_sg" {
  source      = "../.."
  name        = "raw-rules-sg"
  description = "Security group that allows inbound VRRP within the group (IPv4), HTTPS/HTTP open for any (IPv4+IPv6)."

  rules = [
    {
      description = "HTTPS"
      direction   = "ingress"
      protocol    = "tcp"
      port        = 443
    },
    {
      description = "HTTP"
      direction   = "ingress"
      protocol    = "tcp"
      port        = 80
    },
  ]

  rules_ipv4 = [
    {
      description     = "VRRP"
      direction       = "ingress"
      protocol        = "vrrp"
      remote_group_id = "@self"
    },
    {
      description     = "VRRP"
      direction       = "egress"
      protocol        = "vrrp"
      remote_group_id = "@self"
    },
  ]
}

module "ingress_egress_rules_sg" {
  source      = "../.."
  name        = "ingress-egress-rules-sg"
  description = "Security group that allows inbound VRRP within the group (IPv4), HTTPS/HTTP open for any (IPv4+IPv6)."

  ingress_rules = [
    {
      description = "HTTPS"
      protocol    = "tcp"
      port        = 443
    },
    {
      description = "HTTP"
      protocol    = "tcp"
      port        = 80
    },
  ]

  ingress_rules_ipv4 = [
    {
      description     = "VRRP"
      protocol        = "vrrp"
      remote_group_id = "@self"
    },
  ]

  egress_rules_ipv4 = [
    {
      description     = "VRRP"
      protocol        = "vrrp"
      remote_group_id = "@self"
    },
  ]
}

module "ssh_ingress_tagged_sg" {
  source = "../.."

  name        = "ssh-ingress-tagged-sg"
  description = "Security group allows inbound SSH communication from any and group is tagged"

  tags = ["access"]

  ingress_rules = [
    {
      description = "SSH"
      protocol    = "tcp"
      port        = 22
    },
  ]
}

module "do_not_create_sg" {
  source = "../.."

  create      = false
  name        = "do-not-create-sg"
  description = "Security group shall not be created! If you see it then something is wrong."

  ingress_rules = [
    {
      description = "HTTP"
      protocol    = "tcp"
      port        = 8080
    },
  ]
}
