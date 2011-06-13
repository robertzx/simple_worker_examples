
#
# TO USE:
# 1) Get accounts/credentials for Klout, SimpleWorker, and AWS/SimpleDB
#
# 2) Create a file in this directory called config.yml with the following parameters:
# (Note: Your keys will be different than below. Get the right values from each service.)
#
# sw_access_key: ABC
# sw_secret_key: XYZ
# klout_api_key: ABC
# twitter_usernames: ["simpleworker", "klout", "techcrunch"]
# aws_access_key: ABC
# aws_secret_key: XYZ
#

require 'simple_worker'
require 'yaml'
require 'json'
require 'open-uri'
require 'rest-client'

# Require_relative on the class name will also work
load "klout_simpledb_worker.rb"

@config = YAML.load_file('config.yml')
p @config

SimpleWorker.configure do |config|
  config.access_key = @config["sw_access_key"]
  config.secret_key = @config["sw_secret_key"]
end

# Create the worker and set some attributes
ksw = KloutSimpleDBWorker.new
ksw.klout_api_key = @config["klout_api_key"]
ksw.twitter_usernames = @config["twitter_usernames"]

ksw.aws_access_key = @config["aws_access_key"]
ksw.aws_secret_key = @config["aws_secret_key"]


# Run the job (with several alternatives included)
#
#ksw.run_local
#ksw.schedule(:start_at => 2.minutes.since, :run_every => 60, :run_times => 2)
#ksw.queue(:priority=>2)

ksw.queue



# This gets stats on the job after completion. You can see the same in the
# SimpleWorker dashboard.
#
# Note that wait_until_complete has issues with run_local and schedule.
# Included for use with .queue so that we can display the log file.
#
status = ksw.wait_until_complete
p status
puts ksw.get_log
