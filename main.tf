terraform {
  required_version = ">= 0.13"
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

resource "random_id" "this" {
  count       = var.create && var.use_name_prefix && var.name_prefix == "" ? 1 : 0
  byte_length = 8
}

##################################
# Get ID of created Security Group
##################################
locals {
  this_sg_id = concat(
    openstack_networking_secgroup_v2.this.*.id,
    [""],
  )[0]
  this_sg_name = var.use_name_prefix ? (var.name_prefix == "" ? "${random_id.this[0].hex}-${var.name}" : "${var.name_prefix}-${var.name}") : var.name
}


################
# Security group
################
resource "openstack_networking_secgroup_v2" "this" {
  count = var.create && false == var.use_name_prefix ? 1 : 0

  name        = local.this_sg_name
  description = var.description

  tags = var.tags

  delete_default_rules = var.delete_default_rules
  lifecycle {
    create_before_destroy = true
  }
}

######################
# Security group rules
######################
locals {
  ingress_rules_ipv4 = [for r in var.ingress_rules_ipv4 : merge(r, { direction = "ingress", ethertype = "IPv4" })]
  ingress_rules_ipv6 = [for r in var.ingress_rules_ipv6 : merge(r, { direction = "ingress", ethertype = "IPv6" })]
  ingress_rules      = concat(local.ingress_rules_ipv4, local.ingress_rules_ipv6, [])

  ingress_rules_both_ipv6 = [for r in var.ingress_rules : merge(r, { direction = "ingress", ethertype = "IPv6" })]
  ingress_rules_both_ipv4 = [for r in var.ingress_rules : merge(r, { direction = "ingress", ethertype = "IPv4" })]
  ingress_rules_both      = concat(local.ingress_rules_both_ipv4, local.ingress_rules_both_ipv6, [])

  egress_rules_ipv4 = [for r in var.egress_rules_ipv4 : merge(r, { direction = "egress", ethertype = "IPv4" })]
  egress_rules_ipv6 = [for r in var.egress_rules_ipv6 : merge(r, { direction = "egress", ethertype = "IPv6" })]
  egress_rules      = concat(local.egress_rules_ipv4, local.egress_rules_ipv6, [])

  egress_rules_both_ipv6 = [for r in var.egress_rules : merge(r, { direction = "egress", ethertype = "IPv6" })]
  egress_rules_both_ipv4 = [for r in var.egress_rules : merge(r, { direction = "egress", ethertype = "IPv4" })]
  egress_rules_both      = concat(local.egress_rules_both_ipv4, local.egress_rules_both_ipv6, [])

  rules_ipv4 = [for r in var.rules_ipv4 : merge(r, { ethertype = "IPv4" })]
  rules_ipv6 = [for r in var.rules_ipv6 : merge(r, { ethertype = "IPv6" })]

  rules_both_ipv4 = [for r in var.rules : merge(r, { ethertype = "IPv4" })]
  rules_both_ipv6 = [for r in var.rules : merge(r, { ethertype = "IPv6" })]
  rules_both      = concat(local.rules_both_ipv4, local.rules_both_ipv6, [])

  rules = concat(local.rules_both, local.rules_ipv4, local.rules_ipv6, local.egress_rules_both, local.egress_rules, local.ingress_rules_both, local.ingress_rules, [])
}

resource "openstack_networking_secgroup_rule_v2" "rules" {
  count             = var.create ? length(local.rules) : 0
  security_group_id = local.this_sg_id
  direction         = lookup(local.rules[count.index], "direction", null)

  port_range_min = lookup(local.rules[count.index], "port", lookup(local.rules[count.index], "port_range_min", null))
  port_range_max = lookup(local.rules[count.index], "port", lookup(local.rules[count.index], "port_range_max", null))
  protocol       = lookup(local.rules[count.index], "protocol", null)
  ethertype      = lookup(local.rules[count.index], "ethertype", null)
  description    = lookup(local.rules[count.index], "description", null)
  remote_ip_prefix = (
    lookup(local.rules[count.index], "remote_ip_prefix", null) == null
    ? (
      lookup(local.rules[count.index], "ethertype", null) == "IPv6"
      ? (lookup(local.rules[count.index], "remote_group_id", null) == null ? var.default_ipv6_remote_ip_prefix : null)
      : (lookup(local.rules[count.index], "remote_group_id", null) == null ? var.default_ipv4_remote_ip_prefix : null)
    )
    : lookup(local.rules[count.index], "remote_ip_prefix", null)
  )
  remote_group_id = (
    lookup(local.rules[count.index], "remote_group_id", null) == "@self"
    ? local.this_sg_id
    : lookup(local.rules[count.index], "remote_group_id", null)
  )
}

