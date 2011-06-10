require 'simple_worker'

SETTINGS = YAML.load_file('../config/twilio.yaml')

SimpleWorker.configure do |config|
  config.access_key = SETTINGS["sw_access_key"]
  config.secret_key = SETTINGS["sw_secret_key"]
end

require "./twilio_worker.rb"

tw               = TwilioWorker.new

tw.api_version   = '2010-04-01'
tw.account_sid   = SETTINGS["account_sid"]
tw.account_token = SETTINGS['account_token']
tw.account_number = SETTINGS['account_number']
tw.recipient_phone_number = "+14159353448"

#tw.gmail_username = USERNAME
#tw.gmail_password = PASS
#tw.gmail_domain   = DOMAIN

tw.queue