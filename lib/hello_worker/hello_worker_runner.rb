require 'simple_worker'
load "hello_worker.rb"


# Create a project at SimpleWorker.com and enter your credentials below
#-------------------------------------------------------------------------
SimpleWorker.configure do |config|
  config.access_key = 'ENTER_SW_ACCESS_HERE'
  config.secret_key = 'ENTER_SW_SECRET_HERE'
end
#-------------------------------------------------------------------------

# Create and queue the first worker (twice) with an arbitrary parameter
worker = HelloWorker.new
worker.some_param = "Passing in parameters is easy!"
2.times do
  worker.queue
end


# Create and queue the second worker, this time in the highest priority queue.
worker2 = HelloWorker.new
worker2.some_param = "I am running at the highest priority."
worker2.queue(:priority => 2)


# Now let's create a third worker and schedule it to run in 3 minutes, every minute, 5 times.
worker3 = HelloWorker.new
worker3.some_param = "I should be scheduled to run at a later time."
worker3.schedule(:start_at => 3.minutes.since, :run_every => 60, :run_times => 5)


puts "\nCongratulations you've just queued and scheduled workers in the SimpleWorker cloud!\n\n"
puts "Now go to SimpleWorker.com to view all your jobs running!\n\n"

# That's all there is to it!!! Below you'll see how you can check the status from inside your runner if you want to.

#-----------------------------------------------------------------------------------------------------#

def self.wait_for_task(params={})
  tries  = 0
  status = nil
  sleep 1
  while tries < 60
    status = status_for(params)
    puts 'status = ' + status.inspect
    if status["status"] == "complete" || status["status"] == "error"
      break
    end
    sleep 2
  end
  status
end

def self.status_for(ob)
  if ob.is_a?(Hash)
    ob[:schedule_id] ? WORKER.schedule_status(ob[:schedule_id]) : WORKER.status(ob[:task_id])
  else
    ob.status
  end
end

# If you want your runner to check and display the status of your worker, simply uncomment the next 3 lines.
#puts "\nLet's have the runner (this file) check the status until the workers are complete.\n"
#status = wait_for_task(worker)
#status2 = wait_for_task(worker2)