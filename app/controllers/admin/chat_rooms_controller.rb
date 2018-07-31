class Admin::ChatRoomsController < AdminController
  before_action :set_chat_room, only: %i[show edit update destroy]
  before_action :require_admin, except: [:index]

  def index
    @chat_rooms = ChatRoom.all
  end

  def new
    @chat_room = ChatRoom.new
  end

  def create
    @chat_room = ChatRoom.new(chat_room_params)
    respond_to do |format|
      if @chat_room.save
        format.html { redirect_to admin_chat_rooms_path, notice: 'chat_room was successfully created.' }
        format.json { render action: 'show', status: :created, location: @chat_room }
      else
        format.html { render action: 'new' }
        format.json { render json: admin_chat_rooms_path.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @chat_room.destroy
    respond_to do |format|
      format.html { redirect_to admin_chat_rooms_path }
      format.json { head :no_content }
    end
  end

  def toggle_published
    @chat_room = ChatRoom.find(params[:chat_room_id])

    @chat_room.toggle!(:published)
    if @chat_room.published
      redirect_to admin_chat_rooms_path, notice: 'チャットルームを公開しました。'
    else
      redirect_to admin_chat_rooms_path, notice: 'チャットルームを非公開にしました。'
    end
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  def chat_room_params
    params.require(:chat_room).permit(:title)
  end
end
