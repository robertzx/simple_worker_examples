#--
# Klout_Hello_Worker_Runner
# Developer: Roman Kononov / Ken Fromm
#
# TO USE:
# 1) Get accounts/credentials for Klout and SimpleWorker
#
# 2) Create a file in this directory called config.yml with the following parameters:
# (Note: Your keys will be different than below. Get the right values from each service.)
#
# sw_access_key: ABC
# sw_secret_key: XYZ
# klout_api_key: ABC
# twitter_usernames: ["simpleworker", "klout", "techcrunch"]
#

require 'simple_worker'
require_relative 'klout_hello_worker'

@config = YAML.load_file('config.yml')
p @config

SimpleWorker.configure do |config|
  config.access_key = @config["sw_access_key"]
  config.secret_key = @config["sw_secret_key"]
end

# Create the worker and set some attributes
khw = KloutHelloWorker.new
khw.klout_api_key = @config["klout_api_key"]
khw.twitter_usernames = @config["twitter_usernames"]


# Run the job (with several alternatives included)
#
#khw.run_local
#khw.schedule(:start_at => 2.minutes.since, :run_every => 60, :run_times => 2)
#khw.queue(:priority => 2)

khw.queue


# This gets stats on the job after completion. You can see the same in the
# SimpleWorker dashboard.
#
# Note that wait_until_complete has issues with run_local and schedule.
# Included for use with .queue so that we can display the log file.
#
status = khw.wait_until_complete
p status
puts khw.get_log
