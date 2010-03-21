class Arkiv < ActionMailer::Base
  def reset_password(user, code)
    recipients "#{user.email}"
    from       "OCHS Arkiv <arkiv@ochs.no>"
    subject    "Passord resett"
    sent_on    Time.now
    body       :code => code
  end
end