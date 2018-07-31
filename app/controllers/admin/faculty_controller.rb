class Admin::FacultyController < AdminController
  before_action :set_faculty, only: %i[show edit update destroy]
  before_action :require_admin, except: [:index]

  def index
    @faculties = Faculty.all
  end

  def show
    @faculty = Faculty.find(params[:id])
  end

  def new
    @faculty = Faculty.new
  end

  def create
    @faculty = Faculty.new(faculty_params)
    respond_to do |format|
      if @faculty.save
        format.html { redirect_to admin_faculty_index_path, notice: 'faculty was successfully created.' }
        format.json { render action: 'show', status: :created, location: @faculty }
      else
        format.html { render action: 'new' }
        format.json { render json: admin_faculty_index_path.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    # @path = admin_faculty_index_path
  end

  def update
    respond_to do |format|
      if @faculty.update(faculty_params)
        format.html { redirect_to admin_faculty_index_path, notice: '授業情報をアップデートしました！' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @faculty.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @faculty.destroy
    respond_to do |format|
      format.html { redirect_to admin_faculty_index_url }
      format.json { head :no_content }
    end
  end

  private

  def set_faculty
    @faculty = Faculty.find(params[:id])
  end

  def faculty_params
    params.require(:faculty).permit(:faculty_name)
  end
end
