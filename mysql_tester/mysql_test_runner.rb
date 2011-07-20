require "simple_worker"
require "yaml"
require "./mysql_test_worker"

@y = YAML.load_file("./database.yml")

SimpleWorker.configure{|c| c.access_key = @y["sw"]["api"]; c.secret_key = @y["sw"]["secret"]}

@w = MySQLTestWorker.new 

@w.db_config = @y["database"]

@w.queue(:priority => 2)

#@w.run_local
