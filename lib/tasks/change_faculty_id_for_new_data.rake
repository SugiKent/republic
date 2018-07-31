desc "経営の授業のfaculty_idを書き換えます。"
task "onetime:change_keiei_faculty_id" => :environment do
  Lesson.where('id < 2053').where(faculty_id: 4).each do |lesson|
    lesson.faculty_id = 3
    lesson.save
  end
end
