require 'open-uri'

class TelegramService
  class << self
    VOICE_MSG_LIMIT = 15

    def handle(message)
      if message.voice.present?
        if compliant?(message)
          user = UserService.create_from_telegram(message.from)

          data = TelegramMessenger.loadFile(message.voice.file_id)
          result = GoogleCloudService.recognize(data, user.language)
          Rails.logger.info("CHANNEL: #{message.chat.id}, TRANSCRIBED AS: #{result}, LANGUAGE: #{user.language}")

          result
        else
          'Voice message is too long. Currently support messages under 15 seconds.' unless compliant?(message)
        end
      end
    end

    def compliant?(message)
      message.voice.duration < VOICE_MSG_LIMIT
    end
  end
end
