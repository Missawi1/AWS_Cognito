output "my-identity-pool_id" {
  value = aws_cognito_identity_pool.my-identity-pool.id
}

output "identity_provider_id" {
  value = aws_cognito_identity_provider.Google.id
}

output "identity_provider_id" {
  value = aws_cognito_identity_provider.Facebook.id
}
