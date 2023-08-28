class UserMailer < ApplicationMailer
    default from: "lightmfb.com"

    def welcome_email(user)
        @user = user     
        mail(to: @user.email, subject: 'Welcome to XpensFlo')
        puts "sent email to user"
    end
end
