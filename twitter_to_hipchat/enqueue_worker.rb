require 'simple_worker'
require 'yaml'
require 'active_support/core_ext'

SETTINGS = YAML.load_file('./config.yml')

SimpleWorker.configure do |config|
  config.access_key = SETTINGS["sw_access_key"]
  config.secret_key = SETTINGS["sw_secret_key"]
end

require_relative "twitter_to_hipchat_worker"

tw = TwitterToHipchatWorker.new

tw.hipchat_api_key = SETTINGS["hipchat_api_key"]
tw.hipchat_room_name = SETTINGS["hipchat_room_name"]
tw.twitter_keyword = SETTINGS['twitter_keyword']

#tw.run_local # for testing
#tw.queue # to have it run once
tw.schedule(:start_at=>1.days.from_now.change(:hour=>3), :run_every=>24*60*60) # to have it recur every day
