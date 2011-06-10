require 'simple_worker'
require 'json'
require 'twilio'

class TwilioWorker < SimpleWorker::Base
  #merge File.join(File.dirname(__FILE__), "twiliolib.rb")
  #merge_worker File.join(File.dirname(__FILE__), "gmail_worker.rb"), "GmailWorker"

  attr_accessor :api_version, :account_sid, :account_token, :account_number, :gmail_username, :gmail_password, :gmail_domain, :recipient_phone_number


  def run
    log "I'm running TwilioWorker!!"
    
    #account = Twilio::RestAccount.new(account_sid, account_token)

    send_sms("Ok is this changing?!")
    
    #get_uncompleted_calls(account)
    #get_volume_stats(account)
  end


  def get_uncompleted_calls(account)
    log "Starting get_uncompleted_calls"

    msg  = "Uncompleted Calls Report"
    
    resp = account.request("/#{api_version}/Accounts/#{account_sid}/Calls.json", 'GET', {"StartTime" =>Time.now.strftime("%Y-%m-%d"), "Status"=>"failed"})
    resp.error! unless resp.kind_of? Net::HTTPSuccess
    json  = JSON.parse(resp.body)
    calls = json["calls"]
    msg+= ("\nFailed Calls list") if calls.size>0
    calls.each do |call|
      msg+= "\ncall - from #{call["from"]} - to #{call["to"]} ,status - #{call["status"]}, duration #{call["duration"]} " + ''
    end
    msg += "\nTotal failed calls :#{json["total"]}"

    log msg.inspect

    log "Finished with get_uncompleted_calls"
  end


  def get_volume_stats(account)
    log "Starting get_volume_stats"

    msg  = "Get Volume Stats Report"

    resp = account.request("/#{api_version}/Accounts/#{account_sid}/Calls.json", 'GET', {"StartTime" =>Time.now.strftime("%Y-%m-%d")})
    resp.error! unless resp.kind_of? Net::HTTPSuccess
    json = JSON.parse(resp.body)
    msg  += "\nTotal calls :#{json["total"]}"
    resp = account.request("/#{api_version}/Accounts/#{account_sid}/SMS/Messages.json", 'GET', {"DateSent" =>Time.now.strftime("%Y-%m-%d")})
    resp.error! unless resp.kind_of? Net::HTTPSuccess
    json = JSON.parse(resp.body)
    msg  += "\nTotal sms count :#{json["total"]}"


    log msg.inspect

    #send_mail('Daily report', msg, "rkononov@gmail.com")

    log "Finished with get_volume_stats"
  end


  def send_sms(message)
    log "Attempting to send message: #{message}"
    log "account_sid = #{account_sid}"
    log "account_token = #{account_token}"
    log "account_number = #{account_number}"
    log "recipient_phone_number = #{recipient_phone_number}"

    Twilio.connect(account_sid, account_token)
    Twilio::Sms.message(account_number, recipient_phone_number, message)

    log "Done sending SMS!"
  end


  def send_mail(subject, body, to)
    gmail          = GmailWorker.new
    gmail.domain   = gmail_domain
    gmail.username = gmail_username
    gmail.password = gmail_password
    gmail.from     = 'system@simpledeployer.com'
    gmail.to       = to
    gmail.subject  = "[Twilio] #{subject}"
    gmail.body     = body
    gmail.queue
  end

end


