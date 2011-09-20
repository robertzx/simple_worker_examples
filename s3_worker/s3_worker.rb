require 'simple_worker'
require 'open-uri'

class S3Worker < SimpleWorker::Base

  merge_gem "aws"

  attr_accessor :aws_access, :aws_secret, :bucket_name

  def run
    @s3 = Aws::S3Interface.new(aws_access, aws_secret)
    @s3.create_bucket(bucket_name)

    puts 'Downloading file...'
    puts 'user_dir=' + user_dir.inspect

    filename = "ironman.jpg"
    filepath = user_dir + filename

    File.open(filepath, 'wb') do |fo|
      fo.write open("http://fitnessgurunyc.com/wp/wp-content/uploads/2010/12/ironman74.jpg").read
    end

    puts 'Putting file to s3...'
    response = @s3.put(bucket_name, filename, File.open(filepath))
    p response
    link = @s3.get_link(bucket_name, filename)
    puts "VIEW IT HERE: " + link

    #log "Getting file from s3..."
    #@sdb = Aws::SdbInterface.new(@aws_access, @aws_secret)
    #log "All OK!\nGetting domains..."
    #@sdb.list_domains[:domains].each{|x| log x.inspect }
    puts "done!"
  end
end

