# OpenStack Security Group module

Terraform module which creates security groups on OpenStack.

These types of resources are supported:

* [OpenStack Neutron Security Group v2](https://www.terraform.io/docs/providers/openstack/r/networking_secgroup_v2.html)
* [OpenStack Neutron Security Group Rule v2](https://www.terraform.io/docs/providers/openstack/r/networking_secgroup_rule_v2.html)

## Features

This module aims to implement many combinations of arguments supported by OpenStack and latest stable version of Terraform:

* Full control of security group rules if need.
* Ingress and egress rule blocks for convenience.
* Support to separate IPv4 and IPv6 rules in different lists.

## Terraform versions

Terraform 0.12.

## Examples

* [Mixed Security Group examples](https://github.com/haxorof/terraform-openstack-security-group/blob/master/examples/mixed)

## License

This is an open source project under the [MIT](https://github.com/haxorof/terraform-openstack-security-group/blob/master/LICENSE) license.
