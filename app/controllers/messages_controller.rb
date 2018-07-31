class MessagesController < SessionsController
  def create
    Message.create(
      user_id: current_user.try(:id), content: params[:message][:content], messageable_type: 'MatchedUser', messageable_id: params[:message][:conversation_id]
    )
    @conversation = MatchedUser.find(params[:message][:conversation_id])
  end
end
