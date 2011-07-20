require "simple_worker"
require "yaml"
require "./twitter_worker"

@y = YAML.load_file('./twitter.yml')

@sw = @y['simpleworker']

SimpleWorker.configure do |c|
  c.access_key = @sw['api']
  c.secret_key = @sw['secret']
end



@w = TwitterWorker.new
print "How are you feeling today?: "
@w.message = gets.chomp
@w.twitter_config = @y['twitter']
@w.queue
