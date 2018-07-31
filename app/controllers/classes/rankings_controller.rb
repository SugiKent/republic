class Classes::RankingsController < ClassesController
  def index
    @lessons = Lesson.lesson_module_includes
    if params[:faculty_id].present?
      @lessons = @lessons.get_by_faculty(current_user.faculty_id)
    else
      @lessons = @lessons.get_by_faculty(11)
    end
    @lessons = Lesson.same_lessons_with_results(@lessons).desc_lots_of_result.page(1).per(30)

    set_result_ids
  end
end
