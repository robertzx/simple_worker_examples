require 'simple_worker'
require 'json'
require 'open-uri'
require 'rest-client'

SETTINGS = YAML.load_file('../../config/klout.yaml')

SimpleWorker.configure do |config|
  config.access_key = SETTINGS["sw_access_key"]
  config.secret_key = SETTINGS["sw_secret_key"]
end

load "klout_worker.rb"


["rkononov", "treeder", "chadarimura", "frommww"].each do |u|
  kw = KloutWorker.new
  
  kw.usernames = [u]
  kw.klout_api_key = SETTINGS["klout_api_key"]
  kw.aws_access_key = SETTINGS["aws_access_key"]
  kw.aws_secret_key = SETTINGS["aws_secret_key"]
  kw.email_username = SETTINGS["email_username"]
  kw.email_password = SETTINGS["email_password"]
  kw.email_domain = SETTINGS["email_domain"]
  kw.send_to = "chad@appoxy.com"
  kw.title = "Klout daily stats"

  kw.queue(:priority=>1)
end

