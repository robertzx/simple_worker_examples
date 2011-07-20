require "simple_worker"
require "yaml"
require "./sdb_test_worker"

@y = YAML.load_file "./aws.yml"

SimpleWorker.configure{|c| c.access_key = @y["sw"]["api"]; c.secret_key = @y["sw"]["secret"]}

@w = SDBTestWorker.new
@w.aws_access = @y["aws"]["access"]
@w.aws_secret = @y["aws"]["secret"]

@w.queue(:priority => 2)
