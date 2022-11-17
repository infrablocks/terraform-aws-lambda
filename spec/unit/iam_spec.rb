# frozen_string_literal: true

require 'spec_helper'
require 'base64'
require 'digest'

describe 'execution role' do
  let(:region) do
    var(role: :root, name: 'region')
  end
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:account_id) do
    '325795806661'
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.deploy_in_vpc = false
      end
    end

    it 'creates an execution role' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role')
              .once)
    end

    it 'allows the role to be assumed by the lambda service' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role')
              .with_attribute_value(
                :assume_role_policy,
                a_policy_with_statement(
                  Effect: 'Allow',
                  Action: 'sts:AssumeRole',
                  Principal: {
                    Service: 'lambda.amazonaws.com'
                  }
                )
              ))
    end

    it 'includes component and deployment identifiers as tags on the role' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Component: component,
                  DeploymentIdentifier: deployment_identifier
                )
              ))
    end

    it 'creates an execution role policy' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role_policy')
              .once)
    end

    it 'allows log group management' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role_policy')
              .with_attribute_value(
                :policy,
                a_policy_with_statement(
                  Effect: 'Allow',
                  Action: %w[
                    logs:CreateLogGroup
                    logs:CreateLogStream
                    logs:PutLogEvents
                  ],
                  Resource: "arn:aws:logs:#{region}:#{account_id}:*"
                )
              ))
    end

    it 'allows VPC integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role_policy')
              .with_attribute_value(
                :policy,
                a_policy_with_statement(
                  Effect: 'Allow',
                  Action: %w[
                    ec2:CreateNetworkInterface
                    ec2:DescribeNetworkInterfaces
                    ec2:DeleteNetworkInterface
                    ec2:DescribeSecurityGroups
                    ec2:AssignPrivateIpAddresses
                    ec2:UnassignPrivateIpAddresses
                    ec2:DescribeSubnets
                    ec2:DescribeVpcs
                  ],
                  Resource: '*'
                )
              ))
    end

    it 'outputs the IAM role name' do
      expect(@plan)
        .to(include_output_creation(name: 'iam_role_name'))
    end

    it 'outputs the IAM role policy name' do
      expect(@plan)
        .to(include_output_creation(name: 'iam_role_policy_name'))
    end
  end

  describe 'when lambda assume role policy provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.deploy_in_vpc = false
        vars.lambda_assume_role_policy =
          File.read('spec/unit/test-assume-role-policy.json')
      end
    end

    it 'uses the provided assume role policy' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role')
              .with_attribute_value(
                :assume_role_policy,
                a_policy_with_statement(
                  Sid: 'TestAssumeRolePolicy',
                  Effect: 'Allow',
                  Action: 'sts:AssumeRole',
                  Principal: {
                    Service: 'lambda.amazonaws.com'
                  }
                )
              ))
    end
  end

  describe 'when lambda execution role policy provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.deploy_in_vpc = false
        vars.lambda_execution_role_policy =
          File.read('spec/unit/test-execution-role-policy.json')
      end
    end

    it 'uses the provided execution role policy' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role_policy')
              .with_attribute_value(
                :policy,
                a_policy_with_statement(
                  Sid: 'TestExtraExecutionRolePolicyStatement',
                  Effect: 'Allow',
                  Action: 's3:GetObject',
                  Resources: ['*']
                )
              ))
    end
  end
end
