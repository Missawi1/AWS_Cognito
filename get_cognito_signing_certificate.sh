#!/bin/bash

user_pool_id="aws_cognito_user_pool.my-user-pool.id"

region="us-east-1"

certificate=$(aws cognito-idp describe-user-pool --user-pool-id $user_pool_id --region $region --query "UserPool.SigningCertificates" --output text)

echo "{\"certificate\":\"$certificate\"}"
