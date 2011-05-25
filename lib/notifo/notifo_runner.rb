require "simple_worker"
require_relative "notifo_worker.rb"

@y = YAML.load_file('./notifo.yml')

w = SimpleWorker::Examples::NotifoWorker.new
w.notifo_user = @y["notifo_service_user"]
w.notifo_api = @y["notifo_service_key"]

w.task = @y["notifo_task"].to_sym

w.username = @y["username"]
w.message = @y["message"]

if @y["runlocal"] == true
  w.run_local
else
  w.queue
end

puts "Job queued..."
puts "I'll block until it's finished"

w.wait_until_complete

puts "Yay it finished!"
puts "Here is it's log:"

puts w.log

puts "I exit now"
