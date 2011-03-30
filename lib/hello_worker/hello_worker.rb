#--
# Copyright (c) 2011 Chad Arimura
# Developed for SimpleWorker.com
#
# HelloWorker is a very basic worker intended to show how easy it is to queue and run a worker.
# There are no dependencies aside from a SimpleWorker.com account.
#
# 1. Enter your SimpleWorker credentials into hello_worker_runner.rb
# 2. Type 'ruby hello_worker_runner.rb'
#
#
# THESE EXAMPLES ARE INTENDED AS LEARNING AIDS FOR BUILDING WORKERS TO BE USED AT SIMPLEWORKER.COM.
# THEY CAN BE USED IN YOUR OWN CODE AND MODIFIED AS YOU SEE FIT.
#
#++

require 'simple_worker'

class HelloWorker < SimpleWorker::Base

  attr_accessor :some_param

  def run
    log "Starting HelloWorker #{Time.now}\n"
    log "Hey. I'm a worker job, showing how this cloud-based worker thing works. I'll sleep for a little bit so you can see the workers running!"
    log "some_param --> #{some_param}\n"
    sleep 10
    log "Done running HelloWorker #{Time.now}"
  end


end