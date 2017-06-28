class TelegramMessenger
  class << self
    def loadFile(file_id)
      response = Telegram::Bot::Client.run(TELEGRAM_TOKEN) do |bot|
        bot.api.getFile(file_id: file_id)
      end

      raise Errors::TelegramIOException.new(response['description']) unless response['ok']
      url = "https://api.telegram.org/file/bot#{TELEGRAM_TOKEN}/#{response['result']['file_path']}"

      Rails.logger.info("LOADING FILE AT: #{url}")
      open(url).read
    end
  end
end
