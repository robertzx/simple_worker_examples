require 'simple_worker'
require 'json'

class ServerWorker < SimpleWorker::Base
  attr_accessor :worker_ids, :api_key, :api_secret, :app_id
  merge_gem 'signature'
  merge_gem 'pusher'
  def run()
    Pusher.app_id = app_id
    Pusher.key = api_key
    Pusher.secret = api_secret
    worker_ids.each do |w|
      log "Terminating #{w}"
      #sending message via pusher
      Pusher['commands_channel'].trigger!('close', {:id=>w})
    end
  end
end