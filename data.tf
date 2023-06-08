data "aws_route53_zone" "my_app_domain" {
  name = "www.abc321.com"
}

data "aws_cognito_user_pool_signing_certificate" "signing_cert" {
  user_pool_id = aws_cognito_user_pool.my-user-pool.id
}

data "external" "cognito_signing_certificate" {
  program = ["sh", "get_cognito_signing_certificate.sh"]
}
