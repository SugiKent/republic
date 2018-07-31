class PostsController < SessionsController
  def create
    Post.create(
      user_id: current_user.try(:id), chat_room_id: params[:post][:chat_room_id], content: params[:post][:content]
    )
    @room = ChatRoom.find(params[:post][:chat_room_id])
  end
end
