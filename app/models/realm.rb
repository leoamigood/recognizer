module Realm
  class Base
    vattr_initialize :channel, :user, :source
  end

  class Telegram < Base
    def initialize(channel, user)
      super(channel, user, :telegram)
    end
  end

end

