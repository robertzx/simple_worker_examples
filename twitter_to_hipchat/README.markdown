This example will check twitter for search keywords and post to a Hipchat chat room. You can schedule it run every so often if you want to constantly update your room (see enqueue_worker.rb for how to schedule).

Update the config.yml and simply queue or schedule the worker by running enqueue_worker.rb.

You can setup API tokens for Hipchat in the Hipchat admin section. Click API tokens and create one. Twitter search doesn't require authentication (thankfully because it's much more complicated to get a token) so no setup required there.
