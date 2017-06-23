require 'telegram/bot'

TELEGRAM_TOKEN = ENV['TELEGRAM_API_TOKEN']

if Rails.env.production?
  Telegram::Bot::Client.run(TELEGRAM_TOKEN, logger: Logger.new($stderr)) do |bot|
    bot.api.setWebhook(
        url: "#{ENV['TELEGRAM_URL']}/#{ENV['TELEGRAM_WEBHOOK']}",
        max_connections: 50,
        allowed_updates: %w(message)
    )
  end
end
