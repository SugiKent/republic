desc 'Lessonにsame_lessonsを追加します'
task 'onetime:add_same_lessons' => :environment do
  Lesson.all.each do |lesson|
    puts lesson.lesson_name
    same_lessons = Lesson.same_lesson(lesson).pluck(:id)
    lesson.same_lessons = same_lessons.join(",")
    lesson.save
  end
end
