FactoryGirl.define do
  factory :voice, :class => Telegram::Bot::Types::Voice

  trait :short do
    after :build do |voice|
      voice.duration = 2
    end
  end

  trait :long do
    after :build do |voice|
      voice.duration = 16
    end
  end
end
