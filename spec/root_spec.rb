# frozen_string_literal: true

require 'my_target_api'

describe MyTargetApi do
  let(:access_token) { 'Access token' }

  subject { MyTargetApi.new(access_token) }

  it { should respond_to :resource }

  it { should respond_to :get_request }
  it { should respond_to :post_request }
  it { should respond_to :delete_request }
end
