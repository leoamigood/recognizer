require 'google/cloud/speech'

class GoogleCloudService
  class << self
    def recognize(content, language)
      begin
        audio = Google::Cloud::Speech::Audio.new
        audio.instance_variable_set :@speech, $speech
        audio.language = language || 'en-US'
        audio.encoding = :ogg_opus
        audio.sample_rate = 16000
        audio.grpc.content = content

        results = audio.recognize(max_alternatives: 1, profanity_filter: nil)
        Rails.logger.info("TRANSCRIPT: #{results.first.try(:transcript)}")

        results.first.try(:transcript)
      rescue

      end
    end
  end
end
