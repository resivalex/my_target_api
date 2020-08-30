# frozen_string_literal: true

require 'my_target_api'

describe MyTargetApi::Request do
  let(:access_token) { 'myTarget token' }

  let(:request) { MyTargetApi::Request.new }

  describe 'myTarget request types' do
    it { expect(request).to respond_to(:get) }
    it { expect(request).to respond_to(:post) }
    it { expect(request).to respond_to(:delete) }
    it { expect(request).to respond_to(:upload) }
  end

  describe 'request something' do
    it 'return parsed json' do
      allow(MyTargetApi::NetClient).to(
        receive(:post).and_return(double(code: 200, body: '{"name": "Campaign 1"}'))
      )

      result = subject.post('https://target.my.com/api/v1/campaigns.json')

      expect(MyTargetApi::NetClient).to(
        have_received(:post).with('https://target.my.com/api/v1/campaigns.json',
                                  '{}',
                                  Authorization: 'Bearer ')
      )

      expect(result).to eq('name' => 'Campaign 1')
    end

    it 'pass parameters by url in get' do
      allow(MyTargetApi::NetClient).to receive(:get).and_return(double(code: 200, body: '[]'))

      result = subject.get('https://target.my.com/api/v1/vk_groups.json', q: 'unfound')

      expect(MyTargetApi::NetClient).to(
        have_received(:get).with('https://target.my.com/api/v1/vk_groups.json',
                                 params: { q: 'unfound' },
                                 Authorization: 'Bearer ')
      )
      expect(result).to eq([])
    end

    it 'deletes object' do
      allow(MyTargetApi::NetClient).to(
        receive(:delete).and_return(double(code: 200, body: '[{ "success": true }]'))
      )

      result = subject.delete('https://target.my.com/api/v1/remarketing_context_phrases/53.json')

      expect(MyTargetApi::NetClient).to(
        have_received(:delete).with(
          'https://target.my.com/api/v1/remarketing_context_phrases/53.json',
          params: {},
          Authorization: 'Bearer '
        )
      )
      expect(result).to eq([{ 'success' => true }])
    end

    it 'uploads raw content' do
      allow(MyTargetApi::NetClient).to(
        receive(:post).and_return(double(code: 200, body: '{"id": 123, "name": "list"}'))
      )

      result = subject.upload(
        'https://target.my.com/api/v2/search_phrases.json',
        "phrase\nfirst\nsecond",
        name: 'list'
      )

      expect(MyTargetApi::NetClient).to(
        have_received(:post).with(
          'https://target.my.com/api/v2/search_phrases.json',
          "phrase\nfirst\nsecond",
          Authorization: 'Bearer ',
          content_type: 'application/octet-stream',
          params: { name: 'list' }
        )
      )
      expect(result).to eq('id' => 123, 'name' => 'list')
    end

    it 'raises exception on bad statuses' do
      stub_request(:get, 'https://target.my.com/api/v1/wrong_path.json')
        .to_return(body: 'Unknown resource', status: 404)

      expect { subject.get('https://target.my.com/api/v1/wrong_path.json') }
        .to raise_error(MyTargetApi::RequestError, 'Unknown resource')
    end
  end

  describe 'logs' do
    let(:logger) { double('Logger double', '<<': nil) }
    let(:request) { MyTargetApi::Request.new(logger: logger) }

    it 'pass parameters by url in get' do
      logger = double('Logger double', '<<': nil)
      request = MyTargetApi::Request.new(logger: logger)
      allow(MyTargetApi::NetClient).to(
        receive(:get).and_return(double(code: 200,
                                        body: 'response body',
                                        to_s: 'response representation'))
      )

      request.get('https://target.my.com/api/v1/request.json')

      expect(logger).to(have_received(:<<).with("method: Request#get\n"\
        "url: https://target.my.com/api/v1/request.json\n"\
        'params: {}'))
      expect(logger).to(have_received(:<<).with('response representation'))
    end

    it '404' do
      logger = double('Logger double', '<<': nil)
      request = MyTargetApi::Request.new(logger: logger)
      allow(MyTargetApi::NetClient).to(
        receive(:get).and_return(double(body: 'Unknown resource', code: 404, to_s: 'repr'))
      )

      expect { request.get('https://target.my.com/api/v1/request.json') }
        .to raise_error(MyTargetApi::RequestError, 'Unknown resource')

      expect(logger).to(have_received(:<<).with("method: Request#get\n"\
        "url: https://target.my.com/api/v1/request.json\n"\
        'params: {}'))
      expect(logger).to(have_received(:<<).with("          HTTP Code: 404\n"\
                                                "          HTTP Body: Unknown resource\n"))
    end
  end
end
