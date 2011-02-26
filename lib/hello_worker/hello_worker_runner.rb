require 'simple_worker'

load "hello_worker.rb"


worker = HelloWorker.new

3.times do |i|
  worker.iteration = i
  worker.queue
end
