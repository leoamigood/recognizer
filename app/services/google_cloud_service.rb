require 'google/cloud/speech'

class GoogleCloudService
  class << self
    def recognize(content)
      # Rails.logger.info("RECOGNIZE: #{content}")
      # audio = $speech.audio content, encoding: :ogg_opus,
      #                       sample_rate: 16000,
      #                       language:    'en-US'

      audio = Google::Cloud::Speech::Audio.new
      audio.instance_variable_set :@speech, $speech
      audio.encoding = :ogg_opus
      audio.language = 'en-US'
      audio.sample_rate = 16000
      audio.grpc.content = content

      results = audio.recognize
      Rails.logger.info("RESULTS: #{results}")
      Rails.logger.info("TRANSCRIPT: #{results.first.try(:transcript)}")

      results.first.try(:transcript)
    end
  end
end
