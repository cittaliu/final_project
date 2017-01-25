desc 'inactive days notification'

task inactive_days_notification: :environment do
  user = User.last
  UserMailer.inactive_days_email(user).deliver
end
