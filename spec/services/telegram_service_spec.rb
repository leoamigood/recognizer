require 'rails_helper'

describe Telegram::TelegramService, type: :service do

  context 'given a voice message' do
    let!(:message) { build :message,
                           voice: {
                               duration: 1,
                               mime_type: 'audio/ogg',
                               file_id: 'AwADAQADBAADkiBxRkJE0IiYv3-4Ag',
                               file_size: 8671
                           }
    }

    xit 'retrieve voice data' do
      expect(TelegramService.voiceMessage(message)).to be
    end
  end

end
