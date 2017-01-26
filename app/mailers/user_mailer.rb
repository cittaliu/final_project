class UserMailer < ApplicationMailer
  default from: 'kaizenapp123@gmail.com'

  def welcome_email(user)
    p "sending welcome_email"
    @user = user
    @url  = 'https://lit-beyond-99683.herokuapp.com/login'
    mail(to: @user.email, subject: "Welcome to Inked")
  end

  def inactive_days_notification(user)
    @user = user
    @url = 'https://lit-beyond-99683.herokuapp.com/login'
    mail(to: @user.email, subject: "Opportunities slip away")
  end

  def task_overdue_notification(user)
    @user = user
    @url = 'https://lit-beyond-99683.herokuapp.com/login'
    mail(to: @user.email, subject: "You have an overdue task")
  end
end
