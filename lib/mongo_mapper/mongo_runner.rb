# SimpleWorker gem require
require "simple_worker"
# YAML for configuration
require "yaml"
# MongoMapper :D
require "mongo_mapper"

# Model
require_relative "songs"

# YAML configuration parsing
@y = YAML.load_file('./mongo_mapper.yml')

# SimpleWorker configure block
SimpleWorker.configure do |c|
  c.access_key = @y['simpleworker_access']
  c.secret_key = @y['simpleworker_secret']
end

puts "I am configured, creating a worker"

# Modules and everything
# I would suggest putting all of you workers into a module
# Simply for simplicity
w = Mango::MongoMapperWorker.new

# Set the secrets - SSSHHH
w.secrets = {
              :mongo => @y['mongo']
            }

# Let's make the wheels go!
puts "Shovel coal in the engine"
w.queue

puts "Blocking until the job is complete..."
w.wait_until_complete

# Gets the log
puts "Getting log..."
@log = w.get_log

puts "Here is the log:"
puts @log

puts 
puts "That's all folks!
