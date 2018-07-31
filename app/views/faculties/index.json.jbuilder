json.array!(@faculties) do |faculty|
  json.merge! faculty.attributes
  json.departments faculty.departments
end
