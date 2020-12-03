## 0.1.4 (September 9th, 2017) 

IMPROVEMENTS:

* The zone ID and the DNS name of the ELB are now output from the module.   

## 0.1.5 (November 27 2020)

IMPROVEMENTS:

* Added a new `deploy_in_vpc` flag to disable VPC deployments.

   This enables the lambda to be used more easily when you want to access
   global AWS Services without having to configure a VPC or routing. 
   To avoid breaking changes, the default mode is to deploy inside a VPC environment.
   
   When `deploy_in_vpc` is set to "no", the `sg_lambda` security_group is not created 
   and the `vpc_config` is passed empty values to create an AWS Lambda outside of a VPC.

* Added `tags` input to tag terraform managed resources
   
   A map of AWS tags can now be passed in via the `tags` input variable. The default tags are:
    ```json
     {
         "Component" = "<component>",
         "DeploymentType" = "<deployment_type>",
         "DeploymentLabel" = "<deployment_label>",
         "DeploymentIdentifier" = "<deployment_identifier>"
       } 
    ```
* Removed the hard-coded AWS Region and AWS Account Id's in `lambda_execution_policy`.
* Added `include_route53_zone_association = false` to test prerequisites to simplify test harness deployment 
* Added ` "ec2:AssignPrivateIpAddresses", "ec2:UnassignPrivateIpAddresses"` to default execution policy
to bring it inline with Amazon's default AWSLambdaVPCAccessExecutionRole.
* Added an optional `lambda_description` variable
* Added descriptions to variables for improved IDE code hints
* Added `deployment_type` and `deployment_label` variables for tagging resources
