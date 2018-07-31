desc "load test data to development env"
task "db:seed:development" => :environment do
  load(File.join(Rails.root, 'db', 'seeds', 'development.rb'))
end
