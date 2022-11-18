# frozen_string_literal: true

require 'spec_helper'
require 'base64'
require 'digest'

describe 'lambda' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:lambda_function_name) do
    var(role: :root, name: 'lambda_function_name')
  end
  let(:lambda_description) do
    var(role: :root, name: 'lambda_description')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = "handler.hello"
      end
    end

    it 'creates a lambda function' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .once)
    end

    it 'uses the provided function name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:function_name, lambda_function_name))
    end

    it 'uses the provided description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:description, lambda_description))
    end

    it 'uses the provided zip path' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:filename, 'lambda.zip'))
    end

    it 'determines the source code hash from the provided zip path' do
      source_code =
        File.read(
          File.join(
            'spec', 'unit', 'infra', 'root', 'lambda.zip'
          )
        )
      source_code_base64 = Base64.strict_encode64(source_code)
      source_code_sha256 =
        Digest::SHA2.new(256)
                    .base64digest(source_code_base64)
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:source_code_hash, source_code_sha256))
    end

    it 'uses the provided handler' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:handler, 'handler.hello'))
    end

    it 'uses a runtime of "nodejs14.x"' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:runtime, 'nodejs14.x'))
    end

    it 'uses a timeout of 30 seconds' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:timeout, 30))
    end

    it 'uses a memory size of 128MB' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:memory_size, 128))
    end

    it 'does not have any reserved concurrent executions' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:reserved_concurrent_executions, -1))
    end

    it 'does not publish a lambda function version on create or change' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:publish, false))
    end

    it 'includes component and deployment identifiers as tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Component: component,
                  DeploymentIdentifier: deployment_identifier
                )
              ))
    end

    it 'does not include VPC access using the provided subnets' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                [:vpc_config, 0, :subnet_ids],
                a_nil_value
              ))
    end

    it 'does not add a VPC security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                [:vpc_config, 0, :security_group_ids],
                a_nil_value
              ))
    end

    it 'outputs the lambda ID' do
      expect(@plan)
        .to(include_output_creation(name: 'lambda_id'))
    end

    it 'outputs the lambda ARN' do
      expect(@plan)
        .to(include_output_creation(name: 'lambda_arn'))
    end

    it 'outputs the lambda invoke arn' do
      expect(@plan)
        .to(include_output_creation(name: 'lambda_invoke_arn'))
    end

    it 'outputs the lambda qualified arn' do
      expect(@plan)
        .to(include_output_creation(name: 'lambda_qualified_arn'))
    end

    it 'outputs the lambda function name' do
      expect(@plan)
        .to(include_output_creation(name: 'lambda_function_name'))
    end

    it 'outputs the lambda handler' do
      expect(@plan)
        .to(include_output_creation(name: 'lambda_handler'))
    end

    it 'outputs the lambda last modified' do
      expect(@plan)
        .to(include_output_creation(name: 'lambda_last_modified'))
    end

    it 'outputs the lambda memory size' do
      expect(@plan)
        .to(include_output_creation(name: 'lambda_memory_size'))
    end

    it 'outputs the lambda runtime' do
      expect(@plan)
        .to(include_output_creation(name: 'lambda_runtime'))
    end

    it 'outputs the lambda source code hash' do
      expect(@plan)
        .to(include_output_creation(name: 'lambda_source_code_hash'))
    end

    it 'outputs the lambda source code size' do
      expect(@plan)
        .to(include_output_creation(name: 'lambda_source_code_size'))
    end

    it 'outputs the lambda version' do
      expect(@plan)
        .to(include_output_creation(name: 'lambda_version'))
    end
  end

  describe 'when lambda runtime provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = "handler.hello"
        vars.lambda_runtime = 'nodejs16.x'
      end
    end

    it 'uses the provided runtime' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:runtime, 'nodejs16.x'))
    end
  end

  describe 'when lambda timeout provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = "handler.hello"
        vars.lambda_timeout = 60
      end
    end

    it 'uses the provided timeout' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:timeout, 60))
    end
  end

  describe 'when lambda memory size provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = "handler.hello"
        vars.lambda_memory_size = 256
      end
    end

    it 'uses the provided memory size' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:memory_size, 256))
    end
  end

  describe 'when lambda reserved concurrent executions provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = "handler.hello"
        vars.lambda_reserved_concurrent_executions = 10
      end
    end

    it 'uses the provided reserved concurrent executions' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:reserved_concurrent_executions, 10))
    end
  end

  describe 'when lambda environment variables provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = "handler.hello"
        vars.lambda_environment_variables = {
          'VAR1' => 'VAL1',
          'VAR2' => 'VAL2'
        }
      end
    end

    it 'adds each environment variable' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                [:environment, 0, :variables],
                {
                  'VAR1' => 'VAL1',
                  'VAR2' => 'VAL2'
                }
              ))
    end
  end

  describe 'when publish is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = "handler.hello"
        vars.publish = true
      end
    end

    it 'publishes a lambda function version on create or change' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:publish, true))
    end
  end

  describe 'when publish is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = "handler.hello"
        vars.publish = false
      end
    end

    it 'does not publish a lambda function version on create or change' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:publish, false))
    end
  end

  describe 'when include_vpc_access is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = "handler.hello"
        vars.include_vpc_access = true
        vars.vpc_id =
          output(role: :prerequisites, name: 'vpc_id')
        vars.lambda_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
      end
    end

    it 'includes VPC access using the provided subnets' do
      subnet_ids =
        output(role: :prerequisites, name: 'private_subnet_ids')
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                [:vpc_config, 0, :subnet_ids],
                contain_exactly(*subnet_ids)
              ))
    end
  end

  describe 'when include_vpc_access is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = "handler.hello"
        vars.include_vpc_access = false
      end
    end

    it 'does not include VPC access using the provided subnets' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                [:vpc_config, 0, :subnet_ids],
                a_nil_value
              ))
    end

    it 'does not add a VPC security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                [:vpc_config, 0, :security_group_ids],
                a_nil_value
              ))
    end
  end

  describe 'when tags provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = "handler.hello"
        vars.tags = {
          Thing1: 'value1',
          Thing2: 'value2'
        }
      end
    end

    it 'includes the provided tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Thing1: 'value1',
                  Thing2: 'value2'
                )
              ))
    end

    it 'includes component and deployment identifiers as tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Component: component,
                  DeploymentIdentifier: deployment_identifier
                )
              ))
    end
  end
end
