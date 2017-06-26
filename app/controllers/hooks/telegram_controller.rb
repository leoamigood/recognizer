require 'airbrake'
require 'net/http'

class Hooks::TelegramController < BaseApiController

  MAX_VOICE_LENGTH = 15

  Rails.logger = Logger.new(STDOUT)
  def update
    message = Telegram::Bot::Types::Update.new(telegram_params).message

    begin
      text = nil
      if message.voice.present?
        if compliant?(message)
          user = UserService.create_from_telegram(message.from)

          data = TelegramService.voiceMessage(message)
          text = GoogleCloudService.recognize(data, user.language)
        else
          text = 'Voice message is too long. Currently support only messages under 15 seconds' unless compliant?(message)
        end
      end

      render json: Telegram::Response.new(message.chat.id, text)
    rescue => ex
      Rails.logger.warn("Error: #{ex.message}, Stacktrace: #{ex.backtrace}")
      Airbrake.notify(ex, params.to_h)
      render json: Telegram::Response.new(message.chat.id, 'Service is temporary unavailable. Please come later.')
    end
  end

  private

  def compliant?(message)
     message.voice.duration < MAX_VOICE_LENGTH
  end

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
