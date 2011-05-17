#--
# SimpleWorker.com
# Developer: Roman Kononov / Ken Fromm
#
# Klout_HelloWorker is a simple example of how to connect a worker to the Klout API.
#
# There is a klout.rb gem that has some nice methods and error checking but this
# makes the API call directly so you can see the formats.
#
# A set of usernames can be obtained by changing the API param to :users=>twitter_usernames.join(",")
# Of course, you'd want to take out or modify the twitter_usernames do loop.
#
#++

require 'simple_worker'
require 'json'
require 'open-uri'
require 'rest-client'

class KloutHelloWorker < SimpleWorker::Base

  attr_accessor :klout_api_key, :twitter_usernames

  def run
    log "Running Klout HelloWorker"

    twitter_usernames.each do |username|
      begin
        log "Processing username #{username}"

        # Call the Klout API
        response = RestClient.get 'http://api.klout.com/1/klout.json', {:params => {:key => klout_api_key, :users=>username}}
        parsed = JSON.parse(response)

        daily_score = parsed["users"][0]["kscore"] if parsed["users"] && parsed["users"][0]

        log "Processing: #{username}  Score: #{daily_score}"

      rescue =>ex
        puts "EXCEPTION #{ex.inspect}"
      end
    end

    log "Done with Klout HelloWorker!"
  end

end
