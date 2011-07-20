class MySQLTestWorker < SimpleWorker::Base

  merge_gem "sequel"

  attr_accessor :db_config

  def run
    require "mysql2"
    @db = Sequel.connect("mysql2://#{@db_config["username"]}:#{@db_config["password"]}@#{@db_config["host"]}:#{@db_config["port"]}/#{@db_config["database"]}")
    log "Printing database names......."
    @db["SHOW DATABASES;"].each{|x| log x.inspect}
  end

end
