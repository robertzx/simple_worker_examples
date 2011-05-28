# Standard SimpleWorker require
require "simple_worker"
# YAML configuration
require "yaml"
# 1.9.2 sugar:
require_relative "pubnub_worker"

# YAML loading
@y = YAML.load_file("./pubnub.yml")

# SimpleWorker configure
SimpleWorker.configure do |c|
  c.access_key = @y['simpleworker_access']
  c.secret_key = @y['simpleworker_secret']
end

w = PubNubWorker.new

w.secrets = {
              :pubnub_publish => @y['pubnub_publish']
            }

w.message = "B00M!"

w.run_local
