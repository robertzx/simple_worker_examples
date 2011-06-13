require 'simple_worker'
require 'yaml'

SETTINGS = YAML.load_file('../config/face.yaml')
SimpleWorker.configure do |config|
  config.access_key = SETTINGS["sw_access_key"]
  config.secret_key = SETTINGS["sw_secret_key"]
end
load "spy_worker.rb"
tw_username       = "mrskutcher"
fw                = SpyWorker.new
fw.rss_feed       = "http://twitpic.com/photos/#{tw_username}/feed.rss"
fw.api_key        = SETTINGS["api_key"]
fw.api_secret     = SETTINGS["api_secret"]
fw.email_username = SETTINGS["email_username"]
fw.email_password = SETTINGS["email_password"]
fw.email_domain   = SETTINGS["email_domain"]
fw.send_to        = "user@email.com"
fw.title          = "Rss feed of #{tw_username}"
fw.last_date      = 1.years.ago
fw.queue