require "simple_worker"
require "./twitter_worker"

SimpleWorker.configure do |c|
  c.access_key = ''
  c.secret_key = ''
end



@w = TwitterWorker.new
print "How are you feeling today?: "
@w.message = gets.chomp
@w.queue
