# frozen_string_literal: true

require 'spec_helper'

describe 'security group' do
  let(:vpc_id) do
    output(role: :prerequisites, name: 'vpc_id')
  end
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'
      end
    end

    it 'does not create a security group for the lambda' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_security_group'))
    end

    it 'does not create any security group rules for the lambda' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_security_group_rule'))
    end
  end

  describe 'when include_vpc_access is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_vpc_access = true
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'
        vars.vpc_id =
          output(role: :prerequisites, name: 'vpc_id')
        vars.lambda_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
        vars.lambda_ingress_cidr_blocks =
          %w[10.1.0.0/16 10.2.0.0/16]
        vars.lambda_egress_cidr_blocks =
          %w[10.3.0.0/16 10.4.0.0/16]
      end
    end

    it 'creates a security group for the lambda' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .once)
    end

    it 'includes the deployment identifier in the security group description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                :description, including(deployment_identifier)
              ))
    end

    it 'uses the provided VPC ID' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:vpc_id, vpc_id))
    end

    it 'includes component and deployment identifiers as tags on the ' \
       'security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Component: component,
                  DeploymentIdentifier: deployment_identifier
                )
              ))
    end

    it 'creates an ingress rule for the security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'ingress')
              .with_attribute_value(:from_port, 0)
              .with_attribute_value(:to_port, 0)
              .with_attribute_value(:protocol, '-1'))
    end

    it 'uses the provided ingress CIDR blocks on the ingress security ' \
       'group rule' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'ingress')
              .with_attribute_value(
                :cidr_blocks,
                contain_exactly('10.1.0.0/16', '10.2.0.0/16')
              ))
    end

    it 'creates an egress rule for the security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'egress')
              .with_attribute_value(:from_port, 0)
              .with_attribute_value(:to_port, 0)
              .with_attribute_value(:protocol, '-1'))
    end

    it 'uses the provided egress CIDR blocks on the egress security ' \
       'group rule' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'egress')
              .with_attribute_value(
                :cidr_blocks,
                contain_exactly('10.3.0.0/16', '10.4.0.0/16')
              ))
    end

    it 'outputs the security group name' do
      expect(@plan)
        .to(include_output_creation(name: 'security_group_name'))
    end

    it 'outputs the security group ID' do
      expect(@plan)
        .to(include_output_creation(name: 'security_group_id'))
    end
  end

  describe 'when include_vpc_access is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_vpc_access = false
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'
      end
    end

    it 'does not create a security group for the lambda' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_security_group'))
    end

    it 'does not create any security group rules for the lambda' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_security_group_rule'))
    end
  end

  describe 'when lambda ingress cidr blocks provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_vpc_access = true
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'
        vars.vpc_id =
          output(role: :prerequisites, name: 'vpc_id')
        vars.lambda_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
        vars.lambda_ingress_cidr_blocks =
          %w[10.1.0.0/16 10.2.0.0/16]
      end
    end

    it 'uses the provided ingress CIDR blocks on the ingress security ' \
       'group rule' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'ingress')
              .with_attribute_value(
                :cidr_blocks,
                contain_exactly('10.1.0.0/16', '10.2.0.0/16')
              ))
    end
  end

  describe 'when lambda egress cidr blocks provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_vpc_access = true
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'
        vars.vpc_id =
          output(role: :prerequisites, name: 'vpc_id')
        vars.lambda_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
        vars.lambda_egress_cidr_blocks =
          %w[10.3.0.0/16 10.4.0.0/16]
      end
    end

    it 'uses the provided egress CIDR blocks on the egress security ' \
       'group rule' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'egress')
              .with_attribute_value(
                :cidr_blocks,
                contain_exactly('10.3.0.0/16', '10.4.0.0/16')
              ))
    end
  end

  describe 'when tags provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_vpc_access = true
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'
        vars.vpc_id =
          output(role: :prerequisites, name: 'vpc_id')
        vars.lambda_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
        vars.tags = {
          Thing1: 'value1',
          Thing2: 'value2'
        }
      end
    end

    it 'includes the provided tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Thing1: 'value1',
                  Thing2: 'value2'
                )
              ))
    end

    it 'includes component and deployment identifiers as tags on the role' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
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
