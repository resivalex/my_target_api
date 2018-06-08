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
      stub_request(:post, 'https://target.my.com/api/v1/campaigns.json')
        .to_return(body: '{"name": "Campaign 1"}')

      expect(subject.post('https://target.my.com/api/v1/campaigns.json'))
        .to eq('name' => 'Campaign 1')
    end

    it 'pass parameters by url in get' do
      stub_request(:get, 'https://target.my.com/api/v1/vk_groups.json?q=unfound')
        .to_return(body: '[]')

      expect(subject.get('https://target.my.com/api/v1/vk_groups.json', q: 'unfound'))
        .to eq([])
    end

    it 'deletes object' do
      stub_request(:delete, 'https://target.my.com/api/v1/remarketing_context_phrases/53.json')
        .to_return(body: '[{ "success": true }]')

      expect(
        subject.delete('https://target.my.com/api/v1/remarketing_context_phrases/53.json')
      ).to eq([{ 'success' => true }])
    end

    it 'uploads raw content' do
      stub_request(:post, 'https://target.my.com/api/v2/search_phrases.json?name=list')
        .to_return(body: '{"id": 123, "name": "list"}')

      expect(
        subject.upload(
          'https://target.my.com/api/v2/search_phrases.json',
          "phrase\nfirst\nsecond",
          name: 'list'
        )
      ).to eq('id' => 123, 'name' => 'list')
    end

    it 'raises exception on bad statuses' do
      stub_request(:get, 'https://target.my.com/api/v1/wrong_path.json')
        .to_return(body: 'Unknown resource', status: 404)

      expect { subject.get('https://target.my.com/api/v1/wrong_path.json') }
        .to raise_error(MyTargetApi::RequestError, 'Unknown resource')
    end
  end
end
