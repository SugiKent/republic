class ClassRoomsController < SessionsController
  def index
    @rooms = ClassRoom.blank_classrooms([params[:day], params[:hour]])
    if params[:day].present?
      @jigen = { 'day' => params[:day], 'hour' => params[:hour] }
    end
  end
end
