require 'airbrake'
require 'net/http'

class Hooks::TelegramController < BaseApiController
  Rails.logger = Logger.new(STDOUT)
  def update
    update = Telegram::Bot::Types::Update.new(telegram_params)
    begin
      response = TelegramService.handle(update.message)
      render json: Telegram::Response.new(update.message.chat.id, response)
    rescue => ex
      Rails.logger.warn("Error: #{ex.message}, Stacktrace: #{ex.backtrace}")
      Airbrake.notify(ex, params.to_h)
      render json: Telegram::Response.new(update.message.chat.id, 'Service is temporary unavailable. Please try later.')
    end
  end

  private

  def telegram_params
    message = [
        :message_id,
        :text,
        :date,
        from: [:id, :first_name, :last_name, :username, :language_code],
        chat: [:id, :first_name, :last_name, :username, :type],
        voice: [:duration, :mime_type, :file_id, :file_id]
    ]

    params.permit(
        :update,
        :data,
        message: message,
        edited_message: message,
        inline_query: [
            :id,
            :query,
            from: [:id, :first_name, :last_name, :username, :language_code]
        ],
        callback_query: [
            :id,
            :data,
            from: [:id, :first_name, :last_name, :username, :language_code],
            message: message
        ]
    )
  end
end
