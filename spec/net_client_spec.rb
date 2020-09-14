# frozen_string_literal: true

require 'my_target_api'

describe MyTargetApi::NetClient do
  describe '#post' do
    it 'OK' do
      stub_request(:post, 'https://api.com')
        .with(body: 'param1=1&param2[two]=2')
        .to_return(body: 'body')

      expect(
        MyTargetApi::NetClient.post('https://api.com', param1: 1, param2: { two: 2 }).body
      ).to eq('body')
    end

    it 'Content-Type' do
      stub_request(:post, 'https://api.com')
        .with(body: 'payload',
              headers: { 'Content-Type' => 'application/octet-stream' })
        .to_return(body: '{}')

      expect(
        MyTargetApi::NetClient.post('https://api.com',
                                    'payload',
                                    'Content-Type' => 'application/octet-stream').body
      ).to eq('{}')
    end
  end

  describe '#get' do
    it 'OK' do
      stub_request(:get, 'https://api.com?p=3').to_return(body: 'body')

      expect(MyTargetApi::NetClient.get('https://api.com', params: { p: 3 }).body).to eq('body')
    end

    it 'Content-Type' do
      stub_request(:get, 'https://api.com/?param1=1&param2%5Btwo%5D=2')
        .with(headers: { 'Content-Type' => 'application/octet-stream' })
        .to_return(body: '{}')

      expect(MyTargetApi::NetClient.get(
        'https://api.com',
        params: { param1: 1, param2: { two: 2 } },
        'Content-Type' => 'application/octet-stream'
      ).body).to eq('{}')
    end

    it "doesn't catch not RestClient exceptions" do
      test_exception = Class.new(StandardError)
      allow(RestClient).to receive(:get).and_raise(test_exception)

      expect { MyTargetApi::NetClient.get('https://api.com') }.to raise_error(test_exception)
    end

    it ':content_type' do
      stub_request(:get, 'https://api.com')
        .with(headers: { 'Content-Type' => 'application/octet-stream' })
        .to_return(body: 'abc')

      expect(
        MyTargetApi::NetClient.get('https://api.com', content_type: 'application/octet-stream').body
      ).to eq('abc')
    end

    it 'Headers' do
      stub_request(:get, 'https://api.com?p=3')
        .to_return(body: 'body', headers: { 'app-version' => '344354325' })

      result = MyTargetApi::NetClient.get('https://api.com', params: { p: 3 })

      expect(result.body).to eq('body')
      expect(result.code).to eq(200)
      expect(result.headers).to eq('App-Version' => '344354325')
    end

    it '404' do
      stub_request(:get, 'https://api.com').to_return(body: 'not found', status: 404)

      result = MyTargetApi::NetClient.get('https://api.com', {})

      expect(result.body).to eq('not found')
      expect(result.code).to eq(404)
    end

    it '301' do
      stub_request(:get, 'https://api.com')
        .to_return(body: 'not found', status: 301, headers: { 'Location' => 'https://api2.com' })
      stub_request(:get, 'https://api2.com/').to_return(body: 'OK', status: 200)

      result = MyTargetApi::NetClient.get('https://api.com', {})

      expect(result.body).to eq('OK')
      expect(result.code).to eq(200)
    end
  end

  describe '#delete' do
    it 'OK' do
      stub_request(:delete, 'https://api.com').to_return(body: 'body')

      expect(MyTargetApi::NetClient.delete('https://api.com', {}).body).to eq('body')
    end

    it 'Content-Type' do
      stub_request(:delete, 'https://api.com/?param1=1&param2%5Btwo%5D=2')
        .with(headers: { 'Content-Type' => 'application/octet-stream' })
        .to_return(body: '{}')

      expect(MyTargetApi::NetClient.delete(
        'https://api.com',
        params: { param1: 1, param2: { two: 2 } },
        'Content-Type' => 'application/octet-stream'
      ).body).to eq('{}')
    end

    it '404' do
      stub_request(:delete, 'https://api.com').to_return(body: 'not found', status: 404)

      result = MyTargetApi::NetClient.delete('https://api.com', {})

      expect(result.body).to eq('not found')
      expect(result.code).to eq(404)
    end
  end
end
