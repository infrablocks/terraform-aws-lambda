# frozen_string_literal: true

require 'spec_helper'
require 'base64'
require 'digest'

RSpec::Matchers.define_negated_matcher(
  :a_non_nil_value, :a_nil_value
)

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
        vars.lambda_handler = 'handler.hello'
      end
    end

    it 'creates a lambda function' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .once)
    end

    it 'generates a default lambda function name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                :function_name,
                "#{component}-#{deployment_identifier}-default"
              ))
    end

    it 'generates a default lambda description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                :description,
                'Lambda function with name: default for component: ' \
                "#{component} and deployment identifier: " \
                "#{deployment_identifier}."
              ))
    end

    it 'uses a package type of "Zip"' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:package_type, 'Zip'))
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

    it 'does not include any architectures' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:architectures, a_nil_value))
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

    it 'uses created log group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                [:logging_config, 0, :log_group],
                "/#{component}/#{deployment_identifier}/lambda/default"
              ))
    end

    it 'uses a log format of Text' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                [:logging_config, 0, :log_format],
                'Text'
              ))
    end

    it 'does not set an application log level' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                [:logging_config, 0, :application_log_level],
                a_nil_value
              ))
    end

    it 'does not set a system log level' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                [:logging_config, 0, :system_log_level],
                a_nil_value
              ))
    end

    it 'does not include any tracing configuration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                :tracing_config,
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

  describe 'when lambda name provided' do
    before(:context) do
      @lambda_name = 'rest-api'
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'

        vars.lambda_name = @lambda_name
      end
    end

    it 'uses the name in the lambda function name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                :function_name,
                "#{component}-#{deployment_identifier}-#{@lambda_name}"
              ))
    end

    it 'uses the name in the lambda description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                :description,
                "Lambda function with name: #{@lambda_name} for component: " \
                "#{component} and deployment identifier: " \
                "#{deployment_identifier}."
              ))
    end
  end

  describe 'when lambda function name provided' do
    before(:context) do
      @lambda_function_name =
        "my-lambda-#{var(role: :root, name: 'deployment_identifier')}"
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'

        vars.lambda_function_name = @lambda_function_name
      end
    end

    it 'uses the provided lambda function name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                :function_name,
                @lambda_function_name
              ))
    end
  end

  describe 'when lambda description provided' do
    before(:context) do
      @lambda_description = 'My special lambda'
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'

        vars.lambda_description = @lambda_description
      end
    end

    it 'uses the provided lambda description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                :description,
                @lambda_description
              ))
    end
  end

  describe 'when lambda package type is "Image"' do
    describe 'by default' do
      before(:context) do
        @image_uri = output(role: :prerequisites, name: 'image_uri')
        @plan = plan(role: :root) do |vars|
          vars.lambda_package_type = 'Image'
          vars.lambda_image_uri = @image_uri

          # passed to ensure they don't get set
          vars.lambda_zip_path = 'lambda.zip'
          vars.lambda_handler = 'handler.hello'
        end
      end

      it 'does not set a filename' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(:filename, a_nil_value))
      end

      it 'does not set a source code hash' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(:source_code_hash, a_nil_value))
      end

      it 'does not set a handler' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(:handler, a_nil_value))
      end

      it 'uses a package type of "Image"' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(:package_type, 'Image'))
      end

      it 'uses the provided image URI' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(:image_uri, @image_uri))
      end

      it 'does not set an image command' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(
                  [:image_config, 0],
                  a_hash_including(
                    command: a_nil_value
                  )
                ))
      end

      it 'does not set an image working directory' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(
                  [:image_config, 0],
                  a_hash_including(
                    working_directory: a_nil_value
                  )
                ))
      end

      it 'does not set an image entry point' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(
                  [:image_config, 0],
                  a_hash_including(
                    entry_point: a_nil_value
                  )
                ))
      end
    end

    describe 'when image config command provided' do
      before(:context) do
        @image_uri = output(role: :prerequisites, name: 'image_uri')
        @plan = plan(role: :root) do |vars|
          vars.lambda_package_type = 'Image'
          vars.lambda_image_uri = @image_uri
          vars.lambda_image_config = { command: %w[echo hello] }
        end
      end

      it 'uses the provided image command' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(
                  [:image_config, 0],
                  a_hash_including(command: %w[echo hello])
                ))
      end
    end

    describe 'when image config working directory provided' do
      before(:context) do
        @image_uri = output(role: :prerequisites, name: 'image_uri')
        @plan = plan(role: :root) do |vars|
          vars.lambda_package_type = 'Image'
          vars.lambda_image_uri = @image_uri
          vars.lambda_image_config = { working_directory: '/tmp/dir' }
        end
      end

      it 'uses the provided image working directory' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(
                  [:image_config, 0],
                  a_hash_including(working_directory: '/tmp/dir')
                ))
      end
    end

    describe 'when image config entry point provided' do
      before(:context) do
        @image_uri = output(role: :prerequisites, name: 'image_uri')
        @plan = plan(role: :root) do |vars|
          vars.lambda_package_type = 'Image'
          vars.lambda_image_uri = @image_uri
          vars.lambda_image_config = { entry_point: %w[/bin/sh -c] }
        end
      end

      it 'uses the provided image entry point' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(
                  [:image_config, 0],
                  a_hash_including(entry_point: %w[/bin/sh -c])
                ))
      end
    end
  end

  describe 'when lambda package type is "Zip"' do
    describe 'by default' do
      before(:context) do
        @image_uri = output(role: :prerequisites, name: 'image_uri')
        @plan = plan(role: :root) do |vars|
          vars.lambda_package_type = 'Zip'
          vars.lambda_zip_path = 'lambda.zip'
          vars.lambda_handler = 'handler.hello'

          # passed to ensure they don't get set
          vars.lambda_image_uri = @image_uri
        end
      end

      it 'uses a package type of "Zip"' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(:package_type, 'Zip'))
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

      it 'does not set an image URI' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(:image_uri, a_nil_value))
      end
    end

    describe 'when lambda runtime provided' do
      before(:context) do
        @plan = plan(role: :root) do |vars|
          vars.lambda_zip_path = 'lambda.zip'
          vars.lambda_handler = 'handler.hello'
          vars.lambda_runtime = 'nodejs16.x'
        end
      end

      it 'uses the provided runtime' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(:runtime, 'nodejs16.x'))
      end
    end
  end

  describe 'when lambda architectures provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'
        vars.lambda_architectures = ['arm64']
      end
    end

    it 'uses the provided architectures' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:architectures, ['arm64']))
    end
  end

  describe 'when lambda timeout provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'
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
        vars.lambda_handler = 'handler.hello'
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
        vars.lambda_handler = 'handler.hello'
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
        vars.lambda_handler = 'handler.hello'
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
        vars.lambda_handler = 'handler.hello'
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
        vars.lambda_handler = 'handler.hello'
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
        vars.lambda_handler = 'handler.hello'
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
                match_array(subnet_ids)
              ))
    end
  end

  describe 'when include_vpc_access is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'
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
        vars.lambda_handler = 'handler.hello'
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

  describe 'when logging configuration provided' do
    describe 'when optional attributes included' do
      before(:context) do
        @log_group_name = output(role: :prerequisites, name: 'log_group_name')
        @plan = plan(role: :root) do |vars|
          vars.lambda_zip_path = 'lambda.zip'
          vars.lambda_handler = 'handler.hello'
          vars.lambda_logging_config = {
            log_format: 'JSON',
            log_group: @log_group_name,
            application_log_level: 'INFO',
            system_log_level: 'DEBUG'
          }
        end
      end

      it 'uses the provided log format' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(
                  [:logging_config, 0, :log_format],
                  'JSON'
                ))
      end

      it 'uses the provided log group' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(
                  [:logging_config, 0, :log_group],
                  @log_group_name
                ))
      end

      it 'uses the provided application log level' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(
                  [:logging_config, 0, :application_log_level],
                  'INFO'
                ))
      end

      it 'uses the provided system log level' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(
                  [:logging_config, 0, :system_log_level],
                  'DEBUG'
                ))
      end
    end

    describe 'when optional attributes not included' do
      before(:context) do
        @plan = plan(role: :root) do |vars|
          vars.lambda_zip_path = 'lambda.zip'
          vars.lambda_handler = 'handler.hello'
          vars.lambda_logging_config = {
            log_format: 'JSON',
          }
        end
      end

      it 'uses the provided log format' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(
                  [:logging_config, 0, :log_format],
                  'JSON'
                ))
      end

      it 'uses the name of the module managed log group' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(
                  [:logging_config, 0, :log_group],
                  "/#{component}/#{deployment_identifier}/lambda/default"
                ))
      end

      it 'uses a null application log level' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(
                  [:logging_config, 0, :application_log_level],
                  a_nil_value
                ))
      end

      it 'uses a null system log level' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_lambda_function')
                .with_attribute_value(
                  [:logging_config, 0, :system_log_level],
                  a_nil_value
                ))
      end
    end
  end

  describe 'when tracing configuration provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'
        vars.lambda_tracing_config = {
          mode: 'Active'
        }
      end
    end

    it 'uses the provided tracing mode' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                [:tracing_config, 0, :mode],
                'Active'
              ))
    end
  end
end
