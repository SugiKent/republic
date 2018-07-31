class ChatRoomsController < SessionsController
  before_action :set_sidebar, only: %i[index show new]

  def index
    @rooms = ChatRoom.includes(:posts).published.order('chat_rooms.created_at DESC').page(params[:page]).per(21)
  end

  def show
    @room = ChatRoom.find(params[:id])

    @new_post = Post.new(user_id: current_user.try(:id), chat_room_id: params[:id])
  end

  def new
    @room = ChatRoom.new
  end

  def create
    @room = ChatRoom.new(chat_room_params)
    @room.published = true

    # user_idは必須でない
    @room.user_id = current_user.id if current_user.present?

    if @room.save
      flash[:success] = '新しい掲示板を作成しました！'
      redirect_to chat_room_path(@room)
      unless Rails.env.development?
        SlackNotifier.notify_to_slack("掲示板が追加されたよー\n\n---\n\nhttp://www.rep-rikkyo.com/chat_rooms/#{@room.id}\n\n----\n\n#{@room.created_at}", Settings.slack_webhook.added_review)
      end
    else
      render :new, notice: '掲示板の作成に失敗しました。'
    end
  end

  private

  def chat_room_params
    params.require(:chat_room).permit(:title, :faculty_id)
  end

  def set_sidebar
    @ranked_rooms = ChatRoom.published.joins(:posts).group(:chat_room_id).order('count(chat_room_id) DESC').limit(10)
  end
end
