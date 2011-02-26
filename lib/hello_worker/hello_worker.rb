#--
# Copyright (c) 2011 Chad Arimura
# Developed for SimpleWorker.com
#
#
#
#++

require 'simple_worker'

class HelloWorker < SimpleWorker::Base

  attr_accessor :iteration

  def run
    log "Starting HelloWorker"
    log "I am a worker and I'm working hard on iteration ##{iteration}"
    sleep 2
    log "Done running HelloWorker!"
  end


end