class RedisWorker < SimpleWorker::Base
  attr_accessor :redis_connection
  # merge_gem "redis"
  def run
    # For parsing URL's from Redis to Go
    # This will be modified to include an input for "raw" connection data
    require "uri"
    @url = URI.parse(@redis_connection)
    @redis = Redis.new(:host => @url.host, :port => @url.port, :password => @url.password)
    log "We are connected...hit the sax!"

    # Basic operations, although you can do any Redis command here you want

    # SET
    @result = @redis.set("price:type", "fresh")
    log "Set op for \"prince:type\" returned #{@result}"

    # GET
    @result = @redis.get("prince:type")
    log "Set op for \"prince:type\" returned #{@result}"

    # DELETE
    @result = @redis.del("prince:type")
    log "Del op for \"prince:type\" returned #{@result}"
  end
end
