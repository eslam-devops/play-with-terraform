variable "roles" {
  description = "IAM roles configuration"
  type = map(object({
    service              = string
    enabled              = bool
    policies             = optional(list(string), [])
    inline_policies      = optional(map(map(any)), {})
    permissions_boundary = optional(string)
    assume_role_policy   = optional(string)
    tags                 = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for r in var.roles :
      contains([
        "ec2",
        "lambda",
        "ecs-tasks",
        "codebuild",
        "codepipeline",
        "eks",
        "iam"
      ], r.service)
    ])
    error_message = "Unsupported AWS service in IAM role."
  }
}

variable "default_tags" {
  type    = map(string)
  default = {}
}