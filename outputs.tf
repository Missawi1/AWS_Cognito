output "my-identity-pool_id" {
  value = aws_cognito_identity_pool.my-identity-pool.id
}

output "user_pool_id" {
  value = aws_cognito_user_pool.my-user-pool.id
}

output "aws_cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.my-user-pool-client.id
}

output "my-user-pool-domain" {
  value = aws_cognito_user_pool_domain.my-user-pool-domain.domain
}

output "certificate_arn" {
  value = aws_acm_certificate.my-app-cert.arn
}

output "cognito_signing_certificate" {
  value = data.external.cognito_signing_certificate.result.certificate
}

output "identity_provider_id" {
  value = aws_cognito_identity_provider.Google.id
}

output "identity_provider_id" {
  value = aws_cognito_identity_provider.Facebook.id
}