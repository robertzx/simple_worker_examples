require 'yaml'
require 'simple_worker'
settings = YAML.load_file('../config/config.yaml')
SimpleWorker.configure do |config|
  config.access_key = settings["access_key"]
  config.secret_key = settings["secret_key"]
end

load 'mailer_worker.rb'
w = MailerWorker.new
puts settings.inspect
w.gmail_user_name = settings["gmail_user_name"]
w.gmail_password = settings["gmail_password"]
w.send_to = settings["send_to"]
w.queue(:priority=>1)
