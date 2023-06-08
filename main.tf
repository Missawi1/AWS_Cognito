resource "aws_cognito_user_pool" "my-user-pool" {
  name = "my-user-pool"
  auto_verified_attributes = ["Email"]
  
  #Enabling SMS and Software Token Multi-Factor Authentication
  mfa_configuration = "ON"
  sms_authentication_message = "Your verification code is {####}"
  
  software_token_mfa_configuration {
    enabled = true
  }

  #Account recovery setting
  account_recovery_setting {
    recovery_mechanism {
      name = "verified_email"
      priority = 1
    }
  }

  #Settings for profile creation
  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
    from_email_address = "ajiduahawele3@gmail.com"
    
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_LINK"
    email_subject_by_link = "Verify your email"
    email_message_by_link = "Hello {username},\n\nPlease click the following link to verify your email address: {##Click Here##} \n\nThank you,\nOur App Team"
    sms_message {
      body = "Hello {username},\n\nYour verification code is {####}.\n\nThank you,\nOur App Team"
    }
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }

  username_configuration {
    case_sensitive = false
  }

  schema = [
    {
      name = "username"
      attribute_data_type = "String"
      mutable = false
      required = true
    },
    {
      name = "email"
      attribute_data_type = "String"
      mutable = true
      required = true
    },
    {
      name = "phone_number"
      attribute_data_type = "String"
      mutable = true
      required = true
    }
  ]
}

#Creating a user pool client with Cognito as the identity provider
resource "aws_cognito_user_pool_client" "my-user-pool-client" {
  name = "my-user-pool-client"
  user_pool_id = aws_cognito_user_pool.my-user-pool.id

  allowed_oauth_flows_user_pool_client        = true
  allowed_oauth_flows                         = ["code"]
  allowed_oauth_scopes                        = ["openid"]
  callback_urls                               = ["https://example.com/callback"]
  default_redirect_uri                        = "https://example.com/callback"
  generate_secret                             = false
  logout_urls                                 = ["https://example.com/logout"]
  prevent_user_existence_errors               = false
  read_attributes                             = ["email", "phone_number"]
  refresh_token_validity                      = 30
  supported_identity_providers                = ["COGNITO"]
}

#Creating user pool domain
resource "aws_cognito_user_pool_domain" "my-user-pool-domain" {
  domain        = "www.abc321.com/landing-page"
  user_pool_id  = aws_cognito_user_pool.my-user-pool.id
  certificate_arn = aws_acm_certificate.my-app-cert.arn
}

resource "aws_acm_certificate" "my-app-cert" {
  domain_name       = aws_route53_record.my-app-domain.name
  validation_method   = "DNS"

  lifecycle {
    create_before_destroy   = true
  }
}

resource "aws_route53_record" "my-app-domain" {
  name    = aws_cognito_user_pool_domain.my-user-pool-domain.domain
  type    = "A"
  zone_id = data.aws_route53_zone.my-app-domain.zone_id
}
