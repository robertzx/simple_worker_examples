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
        begin
          log "connecting..."
          @notifo = Notifo.new(@notifo_user, @notifo_api)
          log "connected"
    
          if @task == :subscribe
            log "subscribing #{@username}"
            @notifo.subscribe(@username)
          # don't think there is anything else you can do with Notifo
          else
            log "sending #{@message} to #{@username}"
            @notifo.post(@username, @message)
          end
        rescue => ex
          log "ouchie"
          log "#{ex.message} happened"
          log "raising..."
          raise ex
        end
      end
    end
  end
end
