#
# This is a mashup of the Klout HelloWorker example and the MongoWorker example.
#
# TO USE:
# 1) Get accounts/credentials for Klout and SimpleWorker
#
# 2) Create a file in this directory called config.yml with the following parameters:
# (Note: Your keys and values will be different than below. Get the right values from each service.)
#
# sw_access_key: ABC
# sw_secret_key: XYZ
# klout_api_key: ABC
# twitter_usernames: ["simpleworker", "klout", "techcrunch"]
# mongo_host: somehostname.mongohq.com
# mongo_port: somenumber
# mongo_username: ABC
# mongo_password: XYZ
# mongo_db_name: yourdbname
#


require 'simple_worker'

# Require_relative on the class name will also work
load "klout_mongo_worker.rb"

@config = YAML.load_file('config.yml')
p @config

SimpleWorker.configure do |config|
  config.access_key = @config["sw_access_key"]
  config.secret_key = @config["sw_secret_key"]
end




# Create the worker and set some attributes
kmw = KloutMongoWorker.new
kmw.klout_api_key = @config["klout_api_key"]
kmw.twitter_usernames = @config["twitter_usernames"]

kmw.mongo_db_name   = @config["mongo_db_name"]
kmw.mongo_host   = @config["mongo_host"]
kmw.mongo_port   = @config["mongo_port"]
kmw.mongo_username = @config['mongo_username']
kmw.mongo_password = @config['mongo_password']


# Run the job (with several alternatives included)
#
#kmw.run_local
#kmw.schedule(:start_at => 2.minutes.since, :run_every => 60, :run_times => 2)
#kmw.queue(:priority=>2)

kmw.queue


# This gets stats on the job after completion. You can see the same in the
# SimpleWorker dashboard.
#
# Note that wait_until_complete has issues with run_local and schedule.
# Included for use with .queue so that we can display the log file.
#
status = kmw.wait_until_complete
p status
puts kmw.get_log

