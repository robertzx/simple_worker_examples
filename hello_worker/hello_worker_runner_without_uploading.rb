require 'simple_worker'

def wait_for_task(params={})
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

def status_for(ob)
  if ob.is_a?(Hash)
    SimpleWorker.service.status(ob["task_id"])
  else
    ob.status
  end
end

# Create a project at SimpleWorker.com and enter your credentials below
#-------------------------------------------------------------------------
SimpleWorker.configure do |config|
  config.access_key = 'SIMPLEWORKER_ACCESS_KEY'
  config.secret_key = 'SIMPLEWORKER_SECRET_KEY'
end
#-------------------------------------------------------------------------

# queue already uploaded worker with an arbitrary parameter
data={}
#set params without class instance
data[:attr_encoded] = Base64.encode64({'@some_param'=>'Im running without uploading'}.to_json)
#set simpleworker params
data[:sw_config] = SimpleWorker.config.get_atts_to_send
#queue worker
worker_info = SimpleWorker.service.queue('HelloWorker', data,:priority=>2)
#waiting until comlete
wait_for_task(worker_info)