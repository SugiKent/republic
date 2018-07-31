# User生成
for num in 10..99 do
  User.create(
      email: "#{num}aa#{num}0a@rikkyo.ac.jp",
      password: "password",
      confirmed_at: "2016-03-22 08:52:03.98286#{num}"
    )
  p "#{num}aa#{num}0a@rikkyo.ac.jp"
end

for num in 3000..3050 do
  type = num%3 == 0 ? 'TextBook' : 'Document'
  @me = User.last
  @you1 = User.order("RAND()").first
  @you2 = User.order("RAND()").first
  if num%2 == 0
    BookRequest.create(having_user_id: nil, request_user_id: @me.id, requestable_id: num, requestable_type: type)
    BookRequest.create(having_user_id: @you1.id, request_user_id: nil, requestable_id: num, requestable_type: type)
    BookRequest.create(having_user_id: @you2.id, request_user_id: nil, requestable_id: num, requestable_type: type)
  else
    BookRequest.create(having_user_id: nil, request_user_id: @you1.id, requestable_id: num, requestable_type: type)
    BookRequest.create(having_user_id: nil, request_user_id: @you2.id, requestable_id: num, requestable_type: type)
    BookRequest.create(having_user_id: @me.id, request_user_id: nil, requestable_id: num, requestable_type: type)
  end
end
