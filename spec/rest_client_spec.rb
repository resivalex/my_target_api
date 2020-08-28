# frozen_string_literal: true

require 'rest-client'

describe RestClient do
  describe '#post' do
    it 'OK' do
      stub_request(:post, 'https://api.com')
        .with(body: 'param1=1&param2[two]=2')
        .to_return(body: 'body')

      expect(RestClient.post('https://api.com', param1: 1, param2: { two: 2 }).body).to eq('body')
    end

    it 'Content-Type' do
      stub_request(:post, 'https://api.com')
        .with(body: 'payload',
              headers: { 'Content-Type' => 'application/octet-stream' })
        .to_return(body: '{}')

      expect(RestClient.post('https://api.com', 'payload',
                             'Content-Type' => 'application/octet-stream').body).to eq('{}')
    end
  end

  describe '#get' do
    it 'OK' do
      stub_request(:get, 'https://api.com?p=3').to_return(body: 'body')

      expect(RestClient.get('https://api.com', params: { p: 3 }).body).to eq('body')
    end

    it 'Content-Type' do
      stub_request(:get, 'https://api.com/?param1=1&param2%5Btwo%5D=2')
        .with(headers: { 'Content-Type' => 'application/octet-stream' })
        .to_return(body: '{}')

      expect(RestClient.get(
        'https://api.com',
        params: { param1: 1, param2: { two: 2 } },
        'Content-Type' => 'application/octet-stream'
      ).body).to eq('{}')
    end

    it ':content_type' do
      stub_request(:get, 'https://api.com')
        .with(headers: { 'Content-Type' => 'application/octet-stream' })
        .to_return(body: 'abc')

      expect(
        RestClient.get('https://api.com', content_type: 'application/octet-stream').body
      ).to eq('abc')
    end

    it '404' do
      stub_request(:get, 'https://api.com').to_return(body: 'not found', status: 404)

      expect { RestClient.get('https://api.com', {}) }.to raise_exception(RestClient::NotFound)
    end
  end

  describe '#delete' do
    it 'OK' do
      stub_request(:delete, 'https://api.com').to_return(body: 'body')

      expect(RestClient.delete('https://api.com', {}).body).to eq('body')
    end

    it 'Content-Type' do
      stub_request(:delete, 'https://api.com/?param1=1&param2%5Btwo%5D=2')
        .with(headers: { 'Content-Type' => 'application/octet-stream' })
        .to_return(body: '{}')

      expect(RestClient.delete(
        'https://api.com',
        params: { param1: 1, param2: { two: 2 } },
        'Content-Type' => 'application/octet-stream'
      ).body).to eq('{}')
    end

    it '404' do
      stub_request(:delete, 'https://api.com').to_return(body: 'not found', status: 404)

      expect { RestClient.delete('https://api.com', {}) }.to raise_exception(RestClient::NotFound)
    end
  end
end
