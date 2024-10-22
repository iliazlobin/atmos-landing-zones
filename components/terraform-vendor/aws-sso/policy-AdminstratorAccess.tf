locals {
  administrator_access_permission_set = [{
    name               = "AdministratorAccess",
    description        = "Allow Full Admininstrator access to the account",
    relay_state        = "",
    session_duration   = "",
    tags               = {},
    inline_policy      = ""
    policy_attachments = ["arn:${local.aws_partition}:iam::aws:policy/AdministratorAccess"]
  }]
}
