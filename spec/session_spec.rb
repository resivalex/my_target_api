# frozen_string_literal: true

require 'mailru_target'

describe MailruTarget::Session do

  let(:token) { 'myTarget token' }

  subject { MailruTarget::Session.new(token) }

  describe '#read_campaigns' do
    it 'respond to #read_campaigns' do
      is_expected.to respond_to :read_campaigns
    end

    context 'stub myTarget response' do
      it 'return campaign list' do
        stub_request(:get, 'https://target.my.com/api/v1/campaigns.json')
          .to_return(body: { name: 'Campaign 1' }.to_json)

        expect(subject.read_campaigns({})).to eq({ "name" => 'Campaign 1' })
      end
    end
  end

end
