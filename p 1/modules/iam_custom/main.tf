data "aws_iam_policy_document" "default_assume" {
  for_each = local.enabled_roles

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["${each.value.service}.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  for_each = local.enabled_roles

  name = each.key

  assume_role_policy = coalesce(
    each.value.assume_role_policy,
    data.aws_iam_policy_document.default_assume[each.key].json
  )

  permissions_boundary = try(each.value.permissions_boundary, null)

  tags = merge(
    var.default_tags,
    try(each.value.tags, {})
  )

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = {
    for idx, pair in local.role_policy_pairs :
    "${pair.role}-${idx}" => pair
  }

  role       = aws_iam_role.this[each.value.role].name
  policy_arn = each.value.policy
}

resource "aws_iam_role_policy" "inline" {
  for_each = {
    for role_name, role in local.enabled_roles :
    role_name => role.inline_policies
    if length(role.inline_policies) > 0
  }

  role = aws_iam_role.this[each.key].id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = values(each.value)
  })
}

resource "aws_iam_instance_profile" "ec2" {
  for_each = {
    for k, v in local.enabled_roles :
    k => v if v.service == "ec2"
  }

  name = "${each.key}-profile"
  role = aws_iam_role.this[each.key].name
}
