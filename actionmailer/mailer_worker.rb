class MailerWorker < SimpleWorker::Base
  attr_accessor :gmail_user_name,:gmail_password,:send_to
  merge_gem 'actionmailer',:require=>'action_mailer'
  merge_mailer 'mailer', {:path_to_templates=>"mailer"}
  def run
    ActionMailer::Base.smtp_settings={
        :address => "smtp.gmail.com",
        :port => 587,
        :domain => 'gmail.com',
        :user_name => gmail_user_name,
        :password => gmail_password,
        :authentication => 'plain',
        :enable_starttls_auto => true}
    Mailer.test_email(send_to).deliver!
  end
end