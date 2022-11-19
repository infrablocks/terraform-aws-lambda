# frozen_string_literal: true

require 'spec_helper'

describe 'container' do
  let(:lambda_function_name) do
    output(role: :container, name: 'lambda_function_name')
  end
  let(:lambda_image_uri) do
    output(role: :container, name: 'lambda_image_uri')
  end
  let(:security_group_name) do
    output(role: :container, name: 'security_group_name')
  end

  before(:context) do
    apply(role: :container)
  end

  after(:context) do
    destroy(
      role: :container,
      only_if: -> { !ENV['FORCE_DESTROY'].nil? || ENV['SEED'].nil? }
    )
  end

  describe 'lambda' do
    subject { lambda(lambda_function_name) }

    it { is_expected.to(exist) }

    its(:memory_size) { is_expected.to(eq(128)) }
    its(:timeout) { is_expected.to(eq(30)) }
    its(:package_type) { is_expected.to(eq('Image')) }

    it { is_expected.to(have_env_vars(['TEST_ENV_VARIABLE'])) }

    it 'has the correct image URI' do
      lambda_function = lambda_client.get_function(
        function_name: lambda_function_name
      )
      expect(lambda_function.code.image_uri)
        .to(eq(lambda_image_uri))
    end
  end

  describe 'security group' do
    subject { security_group(security_group_name) }

    it { is_expected.to exist }
  end
end
