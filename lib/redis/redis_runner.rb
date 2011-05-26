require "simple_worker"
require_relative "redis_worker"

SimpleWorker.configure do |config|
  config.access_key = '1f4a1dbfaff1f8ea4fe6f70735125e79'
  config.secret_key = 'c21c1b14e7a7c2efadf3bd84fba2cbd3'
end

w = SimpleWorker::Examples::RedisWorker.new
w.redis_connection = ENV['REDIS']

w.queue
