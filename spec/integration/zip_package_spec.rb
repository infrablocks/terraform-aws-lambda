# frozen_string_literal: true

require 'spec_helper'

describe 'zip package' do
  let(:lambda_function_name) do
    output(role: :zip_package, name: 'lambda_function_name')
  end
  let(:lambda_handler) do
    output(role: :zip_package, name: 'lambda_handler')
  end
  let(:security_group_name) do
    output(role: :zip_package, name: 'security_group_name')
  end

  before(:context) do
    apply(role: :zip_package)
  end

  after(:context) do
    destroy(
      role: :zip_package,
      only_if: -> { !ENV['FORCE_DESTROY'].nil? || ENV['SEED'].nil? }
    )
  end

  describe 'lambda' do
    subject { lambda(lambda_function_name) }

    it { is_expected.to(exist) }

    its(:memory_size) { is_expected.to(eq(128)) }
    its(:timeout) { is_expected.to(eq(30)) }
    its(:package_type) { is_expected.to(eq('Zip')) }
    its(:handler) { is_expected.to(eq(lambda_handler)) }
    its(:runtime) { is_expected.to(eq('nodejs16.x')) }

    it { is_expected.to(have_env_vars(['TEST_ENV_VARIABLE'])) }
  end

  describe 'security group' do
    subject { security_group(security_group_name) }

    it { is_expected.to exist }
  end
end
