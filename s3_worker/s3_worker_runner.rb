require "simple_worker"
require "yaml"
require_relative "s3_worker"

@y = YAML.load_file "./s3.yml"

SimpleWorker.configure{|c| c.access_key = @y["sw"]["access_key"]; c.secret_key = @y["sw"]["secret_key"]}

@w = S3Worker.new
@w.aws_access = @y["aws"]["access_key"]
@w.aws_secret = @y["aws"]["secret_key"]
@w.bucket_name = @y["aws"]["bucket_name"]

#@w.run_local
@w.queue(:priority => 1)

status = @w.wait_until_complete
p status
puts @w.get_log
