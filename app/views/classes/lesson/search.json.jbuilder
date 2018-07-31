json.array!(@lessons) do |lesson|
  json.merge! lesson.attributes
  json.department lesson.department.department_name
  json.results lesson.results
  json.url lesson_url(lesson, format: :json)
end
