require 'simple_worker'
load "hello_worker.rb"

# Create a project at SimpleWorker.com to get these credentials
SimpleWorker.configure do |config|
  config.access_key = 'ENTER_SW_ACCESS_HERE'
  config.secret_key = 'ENTER_SW_SECRET_HERE'
end

# Create and queue the first worker (twice) with an arbitrary parameter
worker = HelloWorker.new
worker.some_param = "Passing in parameters is easy!"
2.times do
  worker.queue
end


# Create and queue the second worker, this time in the highest priority queue.
worker2 = HelloWorker.new
worker2.some_param = "I am running at the highest priority."
worker2.queue(:priority => 1)


# Now let's create a third worker and schedule it.
worker3 = HelloWorker.new
worker3.some_param = "I should be scheduled to run at a later time."
worker3.schedule(:start_at => 5.minutes.since)

# Or you can schedule it to run every hour!
#worker3.schedule(:start_at => 1.hours.since, :run_every => 3600)


############# Convenience methods for checking the status of your tasks
def self.wait_for_task(params={})
  tries = 0
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



# Now let's show the status of the two workers we queued
puts "Let's have the runner (this file) check the status until the workers are complete."
status = wait_for_task(worker)
status2 = wait_for_task(worker2)