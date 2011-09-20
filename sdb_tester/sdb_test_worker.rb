class SDBTestWorker < SimpleWorker::Base
  attr_accessor :aws_access, :aws_secret
  merge_gem "right_aws"
  def run
    log "connecting to AWS..."
    @sdb = Aws::SdbInterface.new(@aws_access, @aws_secret)
    log "All OK!\nGetting domains..."
    @sdb.list_domains[:domains].each{|x| log x.inspect }
    log "done!"
  end
end
