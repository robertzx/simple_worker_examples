require 'simple_worker'
require "yaml"
CONFIGS = YAML.load_file('../config/exceptional.yaml')

SimpleWorker.configure do |config|
  config.access_key = CONFIGS["sw_access_key"]
  config.secret_key = CONFIGS["sw_secret_key"]
end
load "exceptional_worker.rb"
ew = ExceptionalWorker.new
ew.api_key = CONFIGS["api_key"]
ew.queue(:priority=>1)
ew.wait_until_complete