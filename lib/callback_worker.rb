# This worker simply calls back to a URL in your application. Great for performing some action
# on your application on a schedule

require 'simple_worker'
require 'httparty'
require 'active_record'

class CallbackWorker < SimpleWorker::Base

  attr_accessor :callback_url

  merge "../models/user"

  def run

    @users = User.all

    @users.each do |user|
      log "posting to #{callback_url}?user_id=#{user.id}"
      HTTParty.post(hook_url, {:body=>{:user_id=>user.id}})
    end

  end

end
