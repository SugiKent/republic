class Classes::ReviewsController < ClassesController
  def index
    @lessons = Lesson.lesson_module_includes.has_comment
    if params[:faculty_id].present?
      @lessons = @lessons.where(faculty_id: params[:faculty_id])
    end
    @lessons = Lesson.same_lessons_with_results(@lessons)
  end
end
