require 'airbrake'
require 'net/http'

class Hooks::TelegramController < BaseApiController

  Rails.logger = Logger.new(STDOUT)
  def update
    begin
      update = Telegram::Bot::Types::Update.new(telegram_params)
      Rails.logger.info("Telegram: Update: #{update}")

      text = nil
      if update.message.voice.present?
        data = TelegramService.voiceMessage(update.message)
        text = GoogleCloudService.recognize(data)
      end

      render json: Telegram::Response.new(update.message.chat.id, text)
    rescue => ex
      Rails.logger.warn("Error: #{ex.message}, Stacktrace: #{ex.backtrace}")
      Airbrake.notify(ex, params.to_h)
      render json: ex.message
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
