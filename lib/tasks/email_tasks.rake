desc 'inactive days notification'

task inactive_days_notification: :environment do
  user = User.first
  UserMailer.inactive_days_notification(user).deliver
end

task task_overdue_notification: :environment do
  @overdue_users = []
  @overdue_users_id = []
  @users = User.all
  @users.each do |user|
    user.usercontacts.each do |task|
      if task.end.to_s.to_time.to_i < Date.today.to_s.to_time.to_i
        @overdue_users_id << task.user.id
      end
    end
  end

  @overdue_users_id = @overdue_users_id.uniq
  @overdue_users_id.each do |overdue_user_id|
    @overdue_users << User.find(overdue_user_id)
  end

  @overdue_users.each do |user|
    UserMailer.task_overdue_notification(user).deliver
  end

end
