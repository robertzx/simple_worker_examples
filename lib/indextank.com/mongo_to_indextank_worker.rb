# Sample worker that connects to MongoDB and iterates through a Mongo collection and puts all of the items into IndexTank for
# full text awesomeness searching.

require 'simple_worker'
require 'mongoid'

class MongoToIndextankWorker < SimpleWorker::Base

#  merge_gem 'faraday-stack', :require=>'faraday_stack'
  merge_gem 'indextank'
  merge 'person'

  attr_accessor :mongo_db, :mongo_host, :mongo_username, :mongo_password,
                :indextank_url


  def run
    init_mongo
    init_indextank

    log "saving person..."
    person = Person.new(:first_name => "Ludwig", :last_name => "Beethoven the #{rand(100)}")
    person.save!
    log person.inspect

    sleep 1

    @index = @indextank.indexes('test_peeps')

    log "querying persons..."
    persons = Person.find(:all, :conditions=>{:first_name=>"Ludwig"})
    persons.each do |p|
      log "indexing #{p.first_name} #{p.last_name} #{p.id}"
      log p.inspect
      doc_id = "person_#{p.id}"
      log doc_id
      @index.document(doc_id).add({:text=>"#{p.first_name} #{p.last_name}"})

    end


  end


  # Configures smtp settings to send email.
  def init_mongo
    Mongoid.configure do |config|
      config.database = Mongo::Connection.new(mongo_host, 27066).db(mongo_db)
      config.database.authenticate(mongo_username, mongo_password)
      config.persist_in_safe_mode = false
    end
  end


  def init_indextank
    @indextank = IndexTank::Client.new(indextank_url)
  end

end
