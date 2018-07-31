desc "Userにdepartmentとfacultyを紐づけます"
task "onetime:add_dep_and_fac" => :environment do
  User.all.each do |user|
    puts user.email

    department = Department.find_by(code: user.email.match(/^\d{2}([a-z]{2})/)[1])
    next if department.blank?
    faculty = department.faculty
    user.department_id = department.id
    user.faculty_id = faculty.id
    user.save
  end
end
