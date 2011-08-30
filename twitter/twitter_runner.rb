require "simple_worker"
require "yaml"
require "./twitter_worker"
require 'active_support/core_ext'

y = YAML.load_file('./twitter.yml')

SimpleWorker.configure do |c|
  c.access_key = y['simpleworker']['api']
  c.secret_key = y['simpleworker']['secret']
end

w = TwitterWorker.new

print "I am: "
w.message = gets.chomp

w.twitter_config = y['twitter']

w.queue(:priority => 2)

w.schedule(:start_at => 1.minutes.from_now,
           :run_every => 60, # seconds
           :run_times => 3,
           :priority => 2)