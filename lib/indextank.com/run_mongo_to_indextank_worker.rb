# TO USE:
# Create a file in this directory called config.yml with the following parameters:

#sw_access_key: ABC
#sw_secret_key: XYZ
#mongo_host: abc.mongohq.com
#mongo_port: 27066
#mongo_username: ABC
#mongo_password: XYZ
#mongo_db_name: workertest # name of database in your mongo instance
#indextank_url: http://:MYTANKID+@1j.api.indextank.com


require 'simple_worker'
require_relative "mongo_to_indextank_worker.rb"


@config = YAML.load_file('config.yml')
p @config

SimpleWorker.configure do |config|
  config.access_key = @config["sw_access_key"]
  config.secret_key = @config["sw_secret_key"]
end


tw               = MongoToIndextankWorker.new
tw.mongo_host   = @config["mongo_host"]
tw.mongo_port = @config["mongo_port"]
tw.mongo_username = @config['mongo_username']
tw.mongo_password = @config['mongo_password']
tw.mongo_db_name = @config["mongo_db_name"]
tw.indextank_url = @config['indextank_url']

#tw.run_local
tw.queue

status = tw.wait_until_complete
p status
puts tw.get_log


