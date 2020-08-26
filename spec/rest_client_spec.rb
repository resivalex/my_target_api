# frozen_string_literal: true

require 'rest-client'

describe RestClient do
  describe '#post' do
    it 'OK' do
      stub_request(:post, 'https://api.com').to_return(body: 'body')

      expect(RestClient.post('https://api.com', {}, {}).body).to eq('body')
    end
  end

  describe '#get' do
    it 'OK' do
      stub_request(:get, 'https://api.com').to_return(body: 'body')

      expect(RestClient.get('https://api.com', {}).body).to eq('body')
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
  end
end
