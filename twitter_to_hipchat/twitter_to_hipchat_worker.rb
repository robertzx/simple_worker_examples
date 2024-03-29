require 'simple_worker'
require 'rest-client'
require 'active_support/core_ext'

class TwitterToHipchatWorker < SimpleWorker::Base
  
  merge_gem 'hipchat-api'

  attr_accessor :hipchat_api_key, :hipchat_room_name,
                :twitter_keyword

  def run
    log self.inspect

    # Search twitter for our keyword
    twitter_search = RestClient.get "http://search.twitter.com/search.json?q=#{twitter_keyword}%20since:#{24.hours.ago.strftime("%Y-%m-%d")}"
    log 'search=' + twitter_search.inspect
    results = JSON.parse(twitter_search)
    
    # Now let's post the results to hipchat
    results['results'].each_with_index do |r, i|
      log 'r=' + r.inspect
      client = HipChat::API.new(hipchat_api_key)
      notify_users = false
      log "posting to hipchat: "
      log client.rooms_message(hipchat_room_name, 'SimpleWorker', "@#{r['from_user']} tweeted: #{r['text']}", notify_users).body
      break if i >= 5
    end

  end

end
