output "security_group_id" {
  description = "The ID of the security group"
  value = concat(
    openstack_networking_secgroup_v2.this.*.id,
    [""],
  )[0]
}

output "security_group_name" {
  description = "The name of the security group"
  value = concat(
    openstack_networking_secgroup_v2.this.*.name,
    [""],
  )[0]
}

output "security_group_description" {
  description = "The description of the security group"
  value = concat(
    openstack_networking_secgroup_v2.this.*.description,
    [""],
  )[0]
}
