# Sample worker that connects to MongoDB and performs some operations.

require 'simple_worker'

class MongoWorker < SimpleWorker::Base

  attr_accessor :mongo_db, :mongo_host, :mongo_username, :mongo_password

  merge 'person'

  def run
    init

    log "saving person..."
    person = Person.new(:first_name => "Ludwig", :last_name => "Beethoven the #{rand(100)}")
    person.save!
    log person.inspect

    sleep 2

    log "querying persons..."

    persons = Person.find(:all, :conditions=>{:first_name=>"Ludwig"})
    persons.each do |p|
      log "found #{p.first_name} #{p.last_name}"
    end


  end

  # Configures smtp settings to send email.
  def init
    Mongoid.configure do |config|
      config.database = Mongo::Connection.new(mongo_host, 27066).db(mongo_db)
      config.database.authenticate(mongo_username, mongo_password)
#      config.slaves = [
#          Mongo::Connection.new(host, 27018, :slave_ok => true).db(name)
#      ]
      config.persist_in_safe_mode = false
    end
  end

end
