class PubNubWorker < SimpleWorker::Base

  # JSON gem is a dep of Pubnub.rb
  merge_gem "json"

  # Merge the Pubnub.rb file
  merge "Pubnub"

  attr_accessor :secrets, :channel, :message

  def run
    # Setup PubNub, now i'm just showing off def's
    pubnub_setup
   

    puts "Channel: #{@channel}"
    puts "Message: #{@message}"

    # Let's rock
    @pubnub.publish({
                      'channel' => @channel,
                      'message' => @message
                    })

    log "Message sent! :D"
  end

  def pubnub_setup
    begin
      @pubnub = Pubnub.new(@secrets[:pubnub_publish], @secrets[:pubnub_secret], @secrets[:pubnub_secret], true)
    rescue => ex
      # Hit an owie
      log "owie: #{ex.message}"
      log "raising for SW's error handling"
      raise ex
    end
  end
end
