module Peteshow
  class Config
    attr_writer :enabled

    def enabled
      @enabled ||= false
    end
  end
end
