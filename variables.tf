#################
# Security group
#################
variable "create" {
  description = "Whether to create security group and all rules"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of security group"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix of security group"
  type        = string
  default     = ""
}

variable "use_name_prefix" {
  description = "Whether to use name_prefix before name or not"
  type        = bool
  default     = false
}

variable "description" {
  type        = string
  description = "Description of security group"
  default     = "Managed by Terraform"
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = set(string)
  default     = []
}

variable "delete_default_rules" {
  type        = bool
  description = "Delete default security group rules"
  default     = true
}

####################
# Defaults for rules
####################
variable "default_ipv4_remote_ip_prefix" {
  description = "Default remote CIDR to use for IPv4"
  type        = string
  default     = "0.0.0.0/0"
}

variable "default_ipv6_remote_ip_prefix" {
  description = "Default remote CIDR to use for IPv6"
  type        = string
  default     = "::/0"
}

###############
# Generic rules
###############
variable "rules" {
  description = "List of ingress and/or egress rules"
  type        = list(map(string))
  default     = []
}

variable "rules_ipv4" {
  description = "List of ingress and/or egress rules"
  type        = list(map(string))
  default     = []
}

variable "rules_ipv6" {
  description = "List of ingress and/or egress rules"
  type        = list(map(string))
  default     = []
}

##########
# Ingress
##########
variable "ingress_rules" {
  description = "List of maps defining ingress rules to create"
  type        = list(map(string))
  default     = []
}

variable "ingress_rules_ipv4" {
  description = "List of maps defining IPv4 ingress rules to create"
  type        = list(map(string))
  default     = []
}

variable "ingress_rules_ipv6" {
  description = "List of maps defining IPv6 ingress rules to create"
  type        = list(map(string))
  default     = []
}

#########
# Egress
#########
variable "egress_rules" {
  description = "List of maps defining egress rules to create"
  type        = list(map(string))
  default     = []
}

variable "egress_rules_ipv4" {
  description = "List of maps defining IPv4 egress rules to create"
  type        = list(map(string))
  default     = []
}

variable "egress_rules_ipv6" {
  description = "List of maps defining IPv6 egress rules to create"
  type        = list(map(string))
  default     = []
}
