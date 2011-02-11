require 'simple_worker'
class TwilioSMSSender < SimpleWorker::Base
  merge File.join(File.dirname(__FILE__), "twiliolib.rb")
  attr_accessor :api_version, :account_sid, :account_token, :to, :from, :body

  def run(data=nil)
    account = Twilio::RestAccount.new(account_sid, account_token)
    #sending sms
    resp    = account.request("/#{api_version}/Accounts/#{account_sid}/SMS/Messages", 'POST', {"From" =>from, "To"=>to, "Body"=>body})
    resp.error! unless resp.kind_of? Net::HTTPSuccess
  end
end
