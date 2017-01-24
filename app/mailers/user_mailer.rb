class UserMailer < ApplicationMailer
  default from: 'kaizenapp123@gmail.com'

  def welcome_email(user)
    @user = user
    @url  = 'https://lit-beyond-99683.herokuapp.com/login'
    mail(to: @user.email, subject: "Welcome to Sophie's Awesome Site")
  end
end
