require 'simple_worker'

load "hello_worker.rb"

SimpleWorker.configure do |config|
  config.access_key = ENTER_SW_ACCESS_HERE
  config.secret_key = ENTER_SW_SECRET_HERE
end

worker = HelloWorker.new
worker.some_param = "Passing in parameters is easy!"
worker.queue

worker2 = HelloWorker.new
worker2.some_param = "I am running at the highest priority."
worker2.queue(:priority => 1)



