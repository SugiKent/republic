desc "Userにtokenを追加します。"
task "onetime:add_token_to_user" => :environment do
  strings = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
  User.all.each do |user|
    random_token = (0...24).map { strings[rand(strings.length)] }.join
    user.update(token: random_token)
  end
end
