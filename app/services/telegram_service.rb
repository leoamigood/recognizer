require 'open-uri'

class TelegramService
  class << self
    def voiceMessage(message)
      file_id = message.voice.file_id
      results = Telegram::Bot::Client.run(TELEGRAM_TOKEN) do |bot|
        bot.api.getFile(file_id: file_id)
      end

      file_path = results['result']['file_path']

      open("https://api.telegram.org/file/bot#{TELEGRAM_TOKEN}/#{file_path}").read
    end
  end
end
