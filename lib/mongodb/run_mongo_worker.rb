# TO USE:
# Create a file in this directory called config.yml with the following parameters:

# sw_access_key: fe86fe23525e008bdf33d55c6a4e0037
#sw_secret_key: afc11e98a05eef217ad5e60c5210a68e
#mongo_host: abc.mongohq.com
#mongo_port: 27066
#mongo_username: ABC
#mongo_password: XYZ


require 'simple_worker'
require_relative "mongo_worker.rb"


@config = YAML.load_file('config.yml')

SimpleWorker.configure do |config|
  config.access_key = @config["sw_access_key"]
  config.secret_key = @config["sw_secret_key"]
end

tw               = MongoWorker.new
tw.mongo_db   = 'workertest'
tw.mongo_host   = @config["mongo_host"]
tw.mongo_username = @config['mongo_username']
tw.mongo_password = @config['mongo_password']

#tw.run_local
tw.queue

status = tw.wait_until_complete
p status
puts tw.get_log


