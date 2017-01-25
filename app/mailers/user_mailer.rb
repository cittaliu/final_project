class UserMailer < ApplicationMailer
  default from: 'kaizenapp123@gmail.com'

  def welcome_email(user)
    @user = user
    @url  = 'https://lit-beyond-99683.herokuapp.com/login'
    mail(to: @user.email, subject: "Welcome to Sophie's Awesome Site")
  end

  def inactive_days_email(user)
    @user = user
    @url  = 'https://lit-beyond-99683.herokuapp.com/login'
    mail(to: @user.email, subject: "Opportunities slip away")
  end
end
