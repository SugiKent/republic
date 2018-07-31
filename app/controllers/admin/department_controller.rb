class Admin::DepartmentController < AdminController
  before_action :set_department, only: %i[show edit update destroy]
  before_action :require_admin, except: [:index]

  def index
    @departments = Department.includes(:faculty).all
  end

  def show
    @department = Department.find(params[:id])
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)
    respond_to do |format|
      if @department.save
        format.html { redirect_to admin_department_index_path, notice: 'department was successfully created.' }
        format.json { render action: 'show', status: :created, location: @department }
      else
        format.html { render action: 'new' }
        format.json { render json: admin_department_index_path.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to @department, notice: '授業情報をアップデートしました！' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to admin_department_index_url }
      format.json { head :no_content }
    end
  end

  private

  def set_department
    @department = Department.find(params[:id])
  end

  def department_params
    params.require(:department).permit(:department_name, :faculty_id)
  end
end
