desc 'inactive days notification'

task inactive_days_notification: :environment do

  @inactive_users_id =[]
  @inactive_users =[]
  @users = User.all
  @users.each do |user|
    user.opportunities.each do |opportunity|
      if ((Time.now.to_i-opportunity.updated_at.to_i)/(60*60*24)) == 0
        @inactive_users_id << opportunity.user_id
      end
    end
  end

  @inactive_users_id = @inactive_users_id.uniq
  @inactive_users_id.each do |inactive_user_id|
    @inactive_users << User.find(inactive_user_id)
  end

  @inactive_users.each do |user|
    UserMailer.inactive_days_notification(user).deliver
  end

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
