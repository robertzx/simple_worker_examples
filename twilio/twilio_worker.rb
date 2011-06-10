class TwilioWorker < SimpleWorker::Base

  merge_gem "twiliolib"

  attr_accessor :secrets, :phone, :message

  def run
    # All ripped out of here: https://github.com/connormontgomery/twilio-ruby/blob/151e701e5ab970e2af6d2ea98e6f0fafcaf05e20/examples/example-rest.rb
    # Connect to Twilio
    @a = Twilio::RestAccount.new(@secrets[:twilio_access], @secrets[:twilio_secret])
    # Now that Twilio is connected
    # Initialize an object to hold to, from, message data with
    @payload = {
      'From' => @secrets[:twilio_validated],
      'To'   => @phone,
      'Body' => @message
    }

    # Do the request...
    resp = account.request("/#{API_VERSION}/Accounts/#{@secrets[:twilio_access]}/SMS/Messages", "POST", @payload)
    # Do some nice logging stuff :D
    log "Respo object looks something like..."
    log resp.inspect
    log "You tell me if it failed or not"

    log ""
    log "That's all folks!"
  end
end
