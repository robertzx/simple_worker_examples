require 'simple_worker'
require 'json'
class ClientWorker < SimpleWorker::Base
  attr_accessor :worker_id, :api_key, :api_secret
  merge_gem 'libwebsocket'
  merge_gem 'pusher-client'
  def run()
    options = {:secret => api_secret}
    socket = PusherClient::Socket.new(api_key, options)
    #connect in async way
    socket.connect(true)
    socket.subscribe('commands_channel')
    @exit = false
    #subscribing to close message
    socket['commands_channel'].bind('close') do |data|
      data = JSON.parse(data)
      puts "worker #{data["id"]} should be terminated"
      unless @exit
        @exit = data["id"] == worker_id
      end
    end
    #never ending loop
    loop do
      sleep(1)
      log "doing hard work"
      if @exit
        log "Hey i'm terminating"
        break
      end
    end
  end
end