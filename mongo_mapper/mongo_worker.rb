# Modules work as expected: all of the files are NOT automerged
module Mango
  class MongoMapperWorker < SimpleWorker::Base
    
    # Merge mongo_mapper and the model
    merge_gem "mongo_mapper"
    merge "songs"

    attr_accessor :secrets

    def run
      log "Attempting to connect to MongoDB"
      mongo_connect
      log "Connected!"

      # Let's get all the songs
      log "Getting songs..."
      @songs = Song.all

     
      # Now, do something funky with the songs
      # Like queue up the search task
      # But ATM, it's gonna print the songs out in pretty format

      # Small collection, I would use pagination/MR for huge tasks
      @songs.each do |song|
        song.like ? type = "like" : type = "don't like"
        log "You #{type} #{song.title} by #{song.artist}"
      end
      log "That's all folks!"
    end

    def mongo_connect
      begin
        # This is for connecting to one server
        # This will differ if you are using a replication set, or master-slave

        require "uri" #unless defined?(URI)
        
        @url = URI.parse(@secrets[:mongo])

        # Connect to Mongo
        MongoMapper.connection = Mongo::Connection.from_uri(@secrets[:mongo])
        MongoMapper.database = @url.path.gsub(/^\//, '')

        # Tada
        return true
      rescue => ex
        log "owie: #{ex.message}"
        raise ex
        return false
      end
    end
  end
end
