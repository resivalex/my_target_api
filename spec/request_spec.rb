# frozen_string_literal: true

require 'my_target_api'

describe MyTargetApi::Request do
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
        receive(:post).and_return(double(code: 200, body: '{"name": "Campaign 1"}', headers: {}))
      )

      result = subject.post('https://target.my.com/api/v1/campaigns.json')

      expect(MyTargetApi::NetClient).to(
        have_received(:post).with('https://target.my.com/api/v1/campaigns.json', '{}', {})
      )

      expect(result).to eq('name' => 'Campaign 1')
    end

    it 'pass parameters by url in get' do
      allow(MyTargetApi::NetClient)
        .to receive(:get).and_return(double(code: 200, body: '[]', headers: {}))

      result = subject.get('https://target.my.com/api/v1/vk_groups.json', q: 'unfound')

      expect(MyTargetApi::NetClient).to(
        have_received(:get).with('https://target.my.com/api/v1/vk_groups.json',
                                 params: { q: 'unfound' })
      )
      expect(result).to eq([])
    end

    it 'deletes object' do
      allow(MyTargetApi::NetClient).to(
        receive(:delete).and_return(double(code: 200, body: '[{ "success": true }]', headers: {}))
      )

      result = subject.delete('https://target.my.com/api/v1/remarketing_context_phrases/53.json')

      expect(MyTargetApi::NetClient).to(
        have_received(:delete).with(
          'https://target.my.com/api/v1/remarketing_context_phrases/53.json',
          params: {}
        )
      )
      expect(result).to eq([{ 'success' => true }])
    end

    it 'uploads raw content' do
      allow(MyTargetApi::NetClient).to(
        receive(:post)
          .and_return(double(code: 200, body: '{"id": 123, "name": "list"}', headers: {}))
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
          'Content-Type' => 'application/octet-stream',
          params: { name: 'list' }
        )
      )
      expect(result).to eq('id' => 123, 'name' => 'list')
    end

    it 'raises exception on bad statuses' do
      stub_request(:get, 'https://target.my.com/api/v1/wrong_path.json')
        .to_return(body: 'Unknown resource', status: 404)

      expect { subject.get('https://target.my.com/api/v1/wrong_path.json') }
        .to raise_error(MyTargetApi::RequestError,
                        '404: Unknown resource. Inspect #params, #response and #original_exception'\
                        ' for more details')
    end

    it 'sets authorization header' do
      allow(MyTargetApi::NetClient).to(
        receive(:get).and_return(double(code: 200,
                                        body: 'response body',
                                        headers: {}))
      )

      request = MyTargetApi::Request.new(access_token: 'my_target_token')
      request.get('https://target.my.com/api/v1/some_path.json')

      expect(MyTargetApi::NetClient).to(
        have_received(:get).with(
          'https://target.my.com/api/v1/some_path.json',
          'Authorization' => 'Bearer my_target_token',
          params: {}
        )
      )
    end
  end

  describe 'logs' do
    let(:logger) { double('Logger double', '<<': nil) }
    let(:request) { MyTargetApi::Request.new(logger: logger) }

    it 'pass parameters by url in get' do
      logger = double('Logger double', '<<': nil)
      options = { logger: logger }
      request = MyTargetApi::LogRequestParametersDecorator.new(
        MyTargetApi::Request.new(options), logger: logger
      )
      allow(MyTargetApi::NetClient).to(
        receive(:get).and_return(double(code: 200,
                                        body: 'response body',
                                        headers: {}))
      )

      request.get('https://target.my.com/api/v1/request.json')

      expect(logger).to(have_received(:<<).with("method: Request#get\n"\
        "url: https://target.my.com/api/v1/request.json\n"\
        'params: {}'))
      expect(logger).to(have_received(:<<).with(<<~LOG))
        HTTP Code: 200
        HTTP Body:
        response body
        HTTP Headers: No headers
      LOG
    end

    it '404' do
      logger = double('Logger double', '<<': nil)
      options = { logger: logger }
      request = MyTargetApi::LogRequestParametersDecorator.new(
        MyTargetApi::Request.new(options), logger: logger
      )
      allow(MyTargetApi::NetClient).to(
        receive(:get).and_return(
          double(
            body: 'Unknown resource',
            code: 404,
            headers: { 'Header': 'Value' }
          )
        )
      )

      expect { request.get('https://target.my.com/api/v1/request.json') }
        .to raise_error(MyTargetApi::RequestError,
                        '404: Unknown resource. Inspect #params, #response and #original_exception'\
                        ' for more details')

      expect(logger).to(have_received(:<<).with("method: Request#get\n"\
        "url: https://target.my.com/api/v1/request.json\n"\
        'params: {}'))
      expect(logger).to(have_received(:<<).with(<<~LOG))
        HTTP Code: 404
        HTTP Body:
        Unknown resource
        HTTP Headers:
        Header: Value
      LOG
    end
  end
end
