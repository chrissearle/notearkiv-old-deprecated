ActionMailer::Base.smtp_settings = {
        :address  => ENV['MAIL_SERVER'],
        :port  => 25,
        :user_name  => ENV['MAIL_ACCOUNT'],
        :password  => ENV['MAIL_PASSWORD'],
        :domain => ENV['MAIL_DOMAIN'],
        :authentication  => :login
}
