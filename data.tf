data "aws_route53_zone" "my_app_domain" {
  name = "www.abc321.com"
}

data "aws_cognito_user_pool_signing_certificate" "signing_cert" {
  user_pool_id = aws_cognito_user_pool.my-user-pool.id
}

data "external" "cognito_signing_certificate" {
  program = ["sh", "get_cognito_signing_certificate.sh"]
}

data "aws_iam_policy_document" "authenticated" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.main.id]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
    }
  }
}

data "aws_iam_policy_document" "authenticated_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "mobileanalytics:PutEvents",
      "cognito-sync:*",
      "cognito-identity:*",
    ]

    resources = ["*"]
  }
}