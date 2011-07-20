class TwitterWorker < SimpleWorker::Base
 
  attr_accessor :message, :twitter_config

  merge_gem "twitter"

  def run
    log "job started"
    configure_twitter
    log "updating with #{@message}"
    Twitter.update @message
    log "Job finished!"
  end

  def configure_twitter
    log "Init twitter..."
    Twitter.configure do |x|
      x.consumer_key       = @twitter_config[:consumer_key]
      x.consumer_secret    = @twitter_config[:consumer_secret]
      x.oauth_token        = @twitter_config[:oauth_token]
      x.oauth_token_secret = @twitter_config[:oauth_token_secret]
    end
    log "Twitter config done!"
  end
end
