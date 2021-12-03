require 'spec_helper'
require 'aws-sdk'

describe 'lambda' do
  context 'lambda' do
    let(:lambda_name) { vars.lambda_function_name }
    let(:handler) { vars.lambda_handler }

    subject { lambda(lambda_name) }
    it { should exist }

    it { should have_env_vars(["TEST_ENV_VARIABLE"]) }

    its(:runtime) { should eq "nodejs14.x" }
    its(:memory_size) { should eq 128 }
    its(:timeout) { should eq 30 }
    its(:handler) { should eq handler }
  end

  context 'security group' do
    let(:security_group_name) do
      output_for(:harness, 'security_group_name')
    end

    subject { security_group(security_group_name) }

    it { should exist }
  end

  context 'IAM policy' do
    # let(:lambda_policy) {output_for(:harness, 'iam_role_policy_name')}
    # subject {iam_policy(lambda_policy)}
    # it {should exist}
  end
end