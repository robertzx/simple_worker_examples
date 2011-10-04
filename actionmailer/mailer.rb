class Mailer < ActionMailer::Base
  default :from => "rkononov@gmail.com"
  def test_email(to)
    mail(:to=>to,
    :subject=>"Sample subject")
  end

end
