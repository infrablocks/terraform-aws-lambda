# frozen_string_literal: true
# # frozen_string_literal: true
#
# require 'spec_helper'
# require 'aws-sdk'
#
# describe 'lambda' do
#   describe 'lambda' do
#     subject { lambda(lambda_name) }
#
#     let(:lambda_name) do
#       var(role: :root, name: 'lambda_function_name')
#     end
#     let(:handler) do
#       var(role: :root, name: 'lambda_handler')
#     end
#
#     it { is_expected.to exist }
#
#     it { is_expected.to have_env_vars(['TEST_ENV_VARIABLE']) }
#
#     its(:runtime) { is_expected.to eq 'nodejs14.x' }
#     its(:memory_size) { is_expected.to eq 128 }
#     its(:timeout) { is_expected.to eq 30 }
#     its(:handler) { is_expected.to eq handler }
#   end
#
#   describe 'security group' do
#     subject { security_group(security_group_name) }
#
#     let(:security_group_name) do
#       output(role: :root, name: 'security_group_name')
#     end
#
#     it { is_expected.to exist }
#   end
# end
