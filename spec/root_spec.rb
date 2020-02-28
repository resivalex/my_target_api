# frozen_string_literal: true

require 'my_target_api'

describe MyTargetApi do
  let(:access_token) { 'Access token' }
  let(:headers) { { accept_language: 'ru-RU,ru' } }

  subject { MyTargetApi.new(access_token, headers) }

  it { should respond_to :resource }

  it { should respond_to :get_request }
  it { should respond_to :post_request }
  it { should respond_to :delete_request }
  it { should respond_to :upload_request }
end
