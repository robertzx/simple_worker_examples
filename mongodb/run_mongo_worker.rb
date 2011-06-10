# TO USE:
# 1) Get accounts/credentials for SimpleWorker and a MongoDB (MongoHQ is pretty cool).
#
# 2) Create a file in this directory called config.yml with the following parameters:
# (Note: Your keys, urls, and names will be different than below. Get the right values from each service.)
#
# sw_access_key: ABC
# sw_secret_key: XYZ
# mongo_host: somehostname.mongohq.com
# mongo_port: somenumber
# mongo_username: ABC
# mongo_password: XYZ
# mongo_db_name: somedbname
#

require 'simple_worker'
require_relative "mongo_worker.rb"

@config = YAML.load_file('config.yml')
p @config

SimpleWorker.configure do |config|
  config.access_key = @config["sw_access_key"]
  config.secret_key = @config["sw_secret_key"]
end

mw               = MongoWorker.new
mw.mongo_db_name   = @config["mongo_db_name"]
mw.mongo_host   = @config["mongo_host"]
mw.mongo_port   = @config["mongo_port"]
mw.mongo_username = @config['mongo_username']
mw.mongo_password = @config['mongo_password']


# Run the job (with several alternatives included)
#
#mw.run_local
#mw.schedule(:start_at => 2.minutes.since, :run_every => 60, :run_times => 2)
#mw.queue(:priority=>2)

mw.queue

# This gets stats on the job after completion. You can see the same in the
# SimpleWorker dashboard.
#
# Note that wait_until_complete has issues with run_local and schedule.
# Included for use with .queue so that we can display the log file.
#

status = mw.wait_until_complete
p status
puts mw.get_log

