# All the sauce in one package
require "simple_worker"
# Configuration comes from this spring of elixir
require "yaml"
# The actual worker, require_relative is 1.9.2 sugar only :(
require_relative "twilio_worker"

# Standard configure block
SimpleWorker.configure do |c|
  c.access_key = @y['simpleworker_access']
  c.secret_key = @y['simpleworker_secret']
end

# Fun starts here
@y = YAML.load_file('twilio.yml')

# Using "w" for a generic variable name
w = TwilioWorker.new

# Set the secrets in one delicious hash
w.secrets = { 
               :twilio_access => @y['twilio_access'],
               :twilio_secret => @y['twilio_secret'],
               :twilio_validated => @y['twilio_validated']
            }

# Set the victim's phone number
w.phone = @y['phone_to_victimize'].to_i
# Set the message
w.message = @y['message'].to_s

w.run_local
