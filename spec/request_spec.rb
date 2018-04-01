# frozen_string_literal: true

require 'my_target_api'

describe MyTargetApi::Request do
  let(:access_token) { 'myTarget token' }

  let(:request) { MyTargetApi::Request.new }

  describe 'myTarget request types' do
    it { expect(request).to respond_to(:get) }
    it { expect(request).to respond_to(:post) }
    it { expect(request).to respond_to(:delete) }
  end

  describe 'request something' do
    it 'return parsed json' do
      stub_request(:get, 'https://target.my.com/api/v1/campaigns.json')
        .to_return(body: '{"name": "Campaign 1"}')

      expect(subject.get('https://target.my.com/api/v1/campaigns.json'))
        .to eq('name' => 'Campaign 1')
    end
  end
end
