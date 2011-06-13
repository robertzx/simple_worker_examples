# TO USE:
# This example builds on the MongoDB example so check out that one first.
#
# 1) Get accounts/credentials for SimpleWorker, IndexTank, and a MongoDB (MongoHQ is pretty cool).
#
# 2) Create a file in this directory called config.yml with the following parameters:
#
# (Note: Your keys, urls, and names will be different than below. Get the right values from each service.)
#
# sw_access_key: ABC
# sw_secret_key: XYZ
# mongo_host: somehostname.mongohq.com
# mongo_port: somenumber
# mongo_username: ABC
# mongo_password: XYZ
# mongo_db_name: yourdbname
# indextank_url: http://someaddress.api.indextank.com
# indextank_index: yourindexname
#
#

require 'simple_worker'
require 'yaml'
require_relative "mongo_to_indextank_worker.rb"

@config = YAML.load_file('config.yml')
p @config

SimpleWorker.configure do |config|
  config.access_key = @config["sw_access_key"]
  config.secret_key = @config["sw_secret_key"]
end


# Some of these items could be placed in the worker directly.
# They're included here to make easier to get the example running.
itw               = MongoToIndextankWorker.new
itw.mongo_host   = @config["mongo_host"]
itw.mongo_port = @config["mongo_port"]
itw.mongo_username = @config['mongo_username']
itw.mongo_password = @config['mongo_password']
itw.mongo_db_name = @config["mongo_db_name"]
itw.indextank_url = @config['indextank_url']
itw.indextank_index = @config['indextank_index']


# Run the job (with several alternatives included)
#
#itw.run_local
#itw.schedule(:start_at => 2.minutes.since, :run_every => 60, :run_times => 2)
#itw.queue(:priority=>2)

itw.queue


# This gets stats on the job after completion. You can see the same in the
# SimpleWorker dashboard.
#
# Note that wait_until_complete has issues with run_local and schedule.
# Included for use with .queue so that we can display the log file.
#
status = itw.wait_until_complete
p status
puts itw.get_log

