# frozen_string_literal: true

require 'spec_helper'
require 'base64'
require 'digest'

RSpec::Matchers.define_negated_matcher(
  :a_non_nil_value, :a_nil_value
)

describe 'log_group' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:lambda_function_name) do
    var(role: :root, name: 'lambda_function_name')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'
      end
    end

    it 'creates a log group for the lambda' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_cloudwatch_log_group')
              .once)
    end

    it 'generates a default log group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_cloudwatch_log_group')
              .with_attribute_value(
                :name,
                "/#{component}/#{deployment_identifier}/lambda/default"))
    end
  end

  describe 'when include_lambda_log_group is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'
        vars.include_lambda_log_group = false
      end
    end

    it 'does not create a log group for the lambda' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_cloudwatch_log_group'))
    end
  end

  describe 'when include_lambda_log_group is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'
        vars.include_lambda_log_group = true
      end
    end

    it 'creates a log group for the lambda' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_cloudwatch_log_group')
              .once)
    end

    it 'generates a default log group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_cloudwatch_log_group')
              .with_attribute_value(
                :name,
                "/#{component}/#{deployment_identifier}/lambda/default"))
    end
  end

  describe 'when lambda_name provided' do
    before(:context) do
      @lambda_name = 'rest-api'
      @plan = plan(role: :root) do |vars|
        vars.lambda_zip_path = 'lambda.zip'
        vars.lambda_handler = 'handler.hello'

        vars.lambda_name = @lambda_name
      end
    end

    it 'generates a log group name using the provided lambda name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_cloudwatch_log_group')
              .with_attribute_value(
                :name,
                "/#{component}/#{deployment_identifier}/lambda/#{@lambda_name}"))
    end
  end
end
