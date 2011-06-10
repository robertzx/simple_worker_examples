require "simple_worker"
require "yaml"
require_relative "redis_worker"

@y = YAML.load_file("redis.yml")

SimpleWorker.configure do |config|
  config.access_key = @y['simpleworker_access']
  config.secret_key = @y['simpleworker_secret']
end

w = RedisWorker.new
w.redis_connection = @y['redis']

w.queue
