locals {
  public_subnet_map = zipmap(var.azs, var.public_subnets)

  ingress_cidr = flatten([
    for sg, v in var.security_groups : [
      for r in v.ingress : {
        sg   = sg
        rule = r
      }
      if try(r.cidr_blocks, null) != null
    ]
  ])

  ingress_sg = flatten([
    for sg, v in var.security_groups : [
      for r in v.ingress : [
        # for ref in try(r.sg_refs, []) : {
        for ref in coalesce(r.sg_refs, []) : {
          sg   = sg
          ref  = ref
          rule = r
        }
      ]
    ]
  ])

  egress_all = flatten([
    for sg, v in var.security_groups : [
      for r in v.egress : {
        sg   = sg
        rule = r
      }
    ]
  ])
}
