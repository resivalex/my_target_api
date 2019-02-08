# frozen_string_literal: true

require 'my_target_api'

describe MyTargetApi::Resource do
  let(:api) { double }
  let(:path) { 'api_path' }

  let(:resource) { MyTargetApi::Resource.new(api, path) }

  describe 'responds to CRUD methods' do
    it { expect(resource).to respond_to :create }
    it { expect(resource).to respond_to :read }
    it { expect(resource).to respond_to :update }
    it { expect(resource).to respond_to :delete }
    it { expect(resource).to respond_to :upload }
  end

  describe '#create' do
    it 'index request path' do
      expect(api).to receive(:post_request).with('api_path.json', param: 'param')
      resource.create(param: 'param')
    end
  end

  describe '#read' do
    it 'index request path' do
      expect(api).to receive(:get_request).with('api_path.json', param: 'param')
      resource.read(param: 'param')
    end

    describe 'request path to a single object' do
      it 'request path to a single object with default id key' do
        expect(api).to receive(:get_request).with('api_path/7.json', param: 'param')
        resource.read(id: 7, param: 'param')
      end

      it 'request path to a single object with custom id key' do
        expect(api).to receive(:get_request).with('api_path/8.json', param: 'param')
        resource.read(id_param_key: :custom_id, custom_id: 8, param: 'param')
      end
    end
  end

  describe '#update' do
    it 'index request path' do
      expect(api).to receive(:get_request).with('api_path.json', param: 'param')
      resource.read(param: 'param')
    end
  end

  describe '#delete' do
    it 'request path to a single object' do
      expect(api).to receive(:delete_request).with('api_path/7.json', param: 'param')
      resource.delete(id: 7, param: 'param')
    end
  end

  describe '#upload' do
    it 'index request path' do
      expect(api).to receive(:upload_request).with('api_path.json', 'content', param: 'param')
      resource.upload('content', param: 'param')
    end
  end

  describe '#resource' do
    let(:nested_resource) { resource.resource('nested') }

    it 'create nested resource' do
      expect(api).to receive(:post_request).with('api_path/nested.json', {})
      nested_resource.create
    end
  end
end
