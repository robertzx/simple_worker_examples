require 'simple_worker'

class SomethingWithUserWorker < SimpleWorker::Base

  attr_accessor :user_id

  def run
    @user = User.find(user_id)

    # Now do something related to the user: send an email, calculate usage, bill/invoice, etc.

  end

end
