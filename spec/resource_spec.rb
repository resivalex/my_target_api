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
  end

  describe '#create' do
    it 'request path to all objects' do
      expect(api).to receive(:post_request).with('api_path.json', {})
      resource.create
    end
  end

  describe '#read' do
    it 'request path to all objects' do
      expect(api).to receive(:get_request).with('api_path.json', {})
      resource.read
    end

    it 'request path to one object' do
      expect(api).to receive(:get_request).with('api_path/7.json', {})
      resource.read(id: 7)
    end
  end

  describe '#update' do
    it 'request path to all objects' do
      expect(api).to receive(:get_request).with('api_path.json', {})
      resource.read
    end
  end

  describe '#delete' do
    it 'request path to all objects' do
      expect(api).to receive(:delete_request).with('api_path/7.json', {})
      resource.delete(id: 7)
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
