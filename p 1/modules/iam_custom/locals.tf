locals {
  enabled_roles = {
    for k, v in var.roles : k => v if v.enabled
  }

  role_policy_pairs = flatten([
    for role_name, role in local.enabled_roles : [
      for policy in role.policies : {
        role   = role_name
        policy = policy
      }
    ]
  ])
}