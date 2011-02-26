#--
# Copyright (c) 2011 Roman Kononov
# Developed for SimpleWorker.com
#
#
#
#++


require 'simple_worker'
require 'simple_record'
require 'json'
require 'open-uri'
require 'rest-client'
require 'aws-ses'

class KloutWorker < SimpleWorker::Base

  merge File.join(File.dirname(__FILE__), "user_klout_stat.rb")
  attr_accessor :usernames, :klout_api_key, :aws_access_key, :aws_secret_key, :sdb_prefix

  def run
    log "Running Klout Worker"

    # Establish connection to SimpleDB
    SimpleRecord.establish_connection(aws_access_key, aws_secret_key, :connection_mode=>:per_thread, :s3_bucket=>:new)
    SimpleRecord::Base.set_domain_prefix("sample_worker_dev_")

    # We only want to store the Klout for each user once per day - so this allows us to check
    today = Time.now.utc.at_beginning_of_day

    # Iterate through the usernames passed into the worker from the runner (or your app)
    usernames.each do |username|
      begin
        log "Processing username #{username}"

        # Call the Klout API
        response = RestClient.get 'http://api.klout.com/1/klout.json', {:params => {:key => klout_api_key, :users=>username}}
        parsed = JSON.parse(response)

        # Check if there's a current score already set for today
        daily_score = UserKloutStat.find(:first, :conditions=>["username=? and for_date=?", username, today])

        # Create if no score today
        daily_score = UserKloutStat.new(:username => username, :for_date => today, :score => 0) unless daily_score
        daily_score.score = parsed["users"][0]["kscore"] if parsed["users"] && parsed["users"][0]

        log "Found daily_score of #{daily_score}"

        daily_score.save
      rescue =>ex
        puts "EXCEPTION #{ex.inspect}"
      end
    end

    log "Done with Klout Worker!"
  end

end