class ActivityLog
  attr_reader :id, :name, :content, :type, :created_at

  def initialize(id, name, content, type, created_at)
    @id = id
    @name = name
    @content = content
    @type = type
    @created_at = created_at
  end

  def self.set_notifications(current_user)
    limit = 20
    rooms = ChatRoom.published.all.limit(limit).reverse_order
    results = Result.includes_fac_dep.user_faculty(current_user).limit(limit).reverse_order
    logs = []

    rooms.each do |r|
      content = "『#{r.title}』という掲示板が作成されました"
      logs << ActivityLog.new(r.id, r.title, content, 'chat_room', r.created_at)
    end
    results.each do |r|
      content = "#{r.lesson.faculty.faculty_name}/#{r.lesson.department.department_name}"
      logs << ActivityLog.new(r.lesson.id, r.lesson.lesson_name, content, 'result', r.created_at)
    end

    logs
  end
end
