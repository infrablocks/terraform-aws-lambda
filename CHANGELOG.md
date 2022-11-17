## Unreleased

BACKWARDS INCOMPATIBILITIES / NOTES:

* This module is now compatible with Terraform 1.1 and higher.
* The `lambda_assume_role` var is now called `lambda_assume_role_policy`.
* The `lambda_execution_policy` var is now called
  `lambda_execution_role_policy`.
* The `account_id` var has been removed and the current account is instead 
  determined from a data resource.
* The `publish` var now accepts a boolean value rather than a "yes"/"no".
* The `deploy_in_vpc` var now accepts a boolean value rather than a "yes"/"no",
  has been renamed to `include_vpc_access` and defaults to false.

## 1.0.0 (May 28th, 2021)

BACKWARDS INCOMPATIBILITIES / NOTES:

* This module is now compatible with Terraform 0.14 and higher. 

## 0.1.5 (November 27 2020)

IMPROVEMENTS:

* Added a new `deploy_in_vpc` flag to disable VPC deployments.

  This enables the lambda to be used more easily when you want to access
  global AWS Services without having to configure a VPC or routing. 
  To avoid breaking changes, the default mode is to deploy inside a VPC
  environment.
   
  When `deploy_in_vpc` is set to "no", the `sg_lambda` security_group is not
  created and the `vpc_config` is passed empty values to create an AWS Lambda
  outside a VPC.

* Added `tags` input to tag terraform managed resources
   
  A map of AWS tags can now be passed in via the `tags` input variable. The
  default tags are:
  ```json
  {
    "Component": "<component>",
    "DeploymentIdentifier": "<deployment_identifier>"
  } 
  ```
* Removed the hard-coded AWS region and AWS account ID's in
  `lambda_execution_policy`.
* Added `include_route53_zone_association = "no"` to test prerequisites to 
  simplify test harness deployment 
* Added `"ec2:AssignPrivateIpAddresses", "ec2:UnassignPrivateIpAddresses"` to
  default execution policy to bring it inline with Amazon's default
  AWSLambdaVPCAccessExecutionRole.
* Added an optional `lambda_description` variable.
* Added descriptions to variables for improved IDE code hints.
