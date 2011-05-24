# This file contains the worker class

module SimpleWorker
  module Examples
    class NotifoWorker < SimpleWorker::Base

    merge_gem "notifo"

    # These are dynamic, and will be different for each user
    attr_accessor :username, :message

    # These should be static, but are accessors for the purposes of keeping API keys secret
    # Sort of like ENV vars in Heroku
    attr_accessor :notifo_user, :notifo_api

    # The SimpleWorker environment will invoke and run this def:
    def run
      
    end

    def notifo
      @notifo = Notifo.new(@notifo_user, @notifo_api)
    end

    end
  end
end
