# This file contains the worker class

module SimpleWorker
  module Examples
    class NotifoWorker < SimpleWorker::Base

    merge_gem "notifo"

    # These are dynamic, and will be different for each task
    attr_accessor :username, :message, :task

    # These should be static, but are accessors for keeping API keys secret
    # Sort of like ENV vars in Heroku
    attr_accessor :notifo_user, :notifo_api

    # The SimpleWorker environment will invoke and run this def:
    def run
      notifo

      case @task
        when :subscribe then subscribe
        when :send then send
      end

    end

    def notifo
      @notifo = Notifo.new(@notifo_user, @notifo_api)
    end

    def subscribe
      @notifo.subscribe_user(@username)
    end

    def send
      @notifo.post(@username, @message)
    end
  end
end
