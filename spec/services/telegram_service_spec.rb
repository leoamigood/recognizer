require 'rails_helper'

describe TelegramService, type: :service do
  let!(:user) { create :user, :telegram, :john_smith }
  let!(:realm) { build :telegram_realm, user: user }

  context 'given a text message' do
    let!(:message) { build :message, :with_realm, text: 'just a text message', realm: realm }

    it 'retrieve voice data' do
      expect(TelegramService.handle(message)).to be nil
    end
  end

  context 'given a voice message' do
    let!(:voice) { build :voice, :short }
    let!(:message) { build :message, :with_realm, voice: voice, realm: realm }

    before do
      allow(TelegramMessenger).to receive(:loadFile).with(message.voice.file_id)
      allow(GoogleCloudService).to receive(:recognize).with(anything(), 'en-GB').and_return('test phrase')
    end

    it 'retrieve voice data' do
      expect(TelegramService.handle(message)).to eq('test phrase')
    end
  end

end
