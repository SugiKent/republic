class UserNotificationsController < SessionsController
  def update_readed_at
    return false if current_user.blank?

    current_user.readed_at = Time.now
    current_user.save

    head :no_content
  end
end
