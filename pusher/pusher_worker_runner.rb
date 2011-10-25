require 'simple_worker'
require 'yaml'
SETTINGS = YAML.load_file('../config/pusher.yaml')

SimpleWorker.configure do |config|
  config.access_key = SETTINGS["sw_access_key"]
  config.secret_key = SETTINGS["sw_secret_key"]
end

load "server_worker.rb"
load "client_worker.rb"
worker_ids=[]
#running clients
5.times do
  cw = ClientWorker.new
  worker_id = rand(999)
  cw.api_key = SETTINGS["api_key"]
  cw.api_secret = SETTINGS["api_secret"]
  cw.worker_id = worker_id
  cw.queue(:timeout=>60)
#wait until worker start
  loop do
    status= cw.status["status"]
    puts "Checking status- #{status}"
    break if ['running', 'error', 'timeout'].include?(status)
  end
  worker_ids<<worker_id
end

# running killer
sw = ServerWorker.new
sw.api_key = SETTINGS["api_key"]
sw.api_secret = SETTINGS["api_secret"]
sw.app_id = SETTINGS["app_id"]
sw.worker_ids = worker_ids
sw.queue()
