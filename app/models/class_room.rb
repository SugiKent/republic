class ClassRoom
  attr_reader :name

  CLASS_ROOMS = {
    ikebukuro: {
      '1': %w[1101 1102 1103 1104 1105 1106 1201 1202 1203 1204 1205 1206],
      '4': %w[4151 4152 4251 4252 4253 4254 4255 4256 4338 4339 4340 4341 4342 4351 4352 4353 4401 4402 4403 4404 4405 4406 4407 4408 4409 4410 4411 4412],
      '5': %w[5121 5122 5123 5124 5125 5126 5201 5202 5203 5204 5205 5206 5207 5208 5209 5210 5212 5213 5214 5215 5216 5221 5222 5223 5224 5301 5302 5303 5304 5305 5306 5307 5308 5309 5321 5322 5323 5324 5401 5402 5403 5404 5405 5406 5407 5408 5409 5501 5502 5503 5504 5505 5506 5507 5508 5509],
      '6': %w[6201 6202 6203 6204 6205 6206 6207 6208 6209 6210 6211 6301 6302 6303 6304 6305 6306 6401 6402 6403 6404 6405 6406 6407 6408 6409 6501 6502 6503 6504 6505 6506],
      '7': %w[7101 7102 720A 7201 7202 7203 7204 7205 7301 7302 7151 7152 7153 7154 7155 7156 7157 7158 7251 7252 7253 7254 7255 7256 7257],
      '8': %w[8101 8201 8202 8301 8302 8303 8304 8402 8403 8404 8501 8502 8503 8504 8505 8506],
      '9': %w[9B01 9B02 9B03 9201 9202 9203 9204 9205 9206 9207 9301 9302 9303 9304 9403 9404],
      'x': %w[x101 x102 x103 x104 x105 x106 x107 x108 x201 x202 x203 x204 x205 x206 x207 x208 x209 x301 x302 x303 x304 x305 x306 x307 x308 x309],
      'a': %w[ab01 a101 a201 a202 a203 a204 a301 a302 a303 a304],
      'd': %w[d201 d301 d302 d401 d402 d501 d502 d601 d602 d603],
      'm': %w[mb01 m201 m202 m301 m302]
    },
    niiza: {
      '1': ['n121'],
      '2': %w[n211 n212 n213 n214 n215 n221 n222 n223 n224 n225 n226 n227 n228 n231 n232 n233 n234 n235 n236 n237 n238 n241 n242 n243 n244 n245 n246 n247 n248],
      '3': %w[n311 n312 n313 n321 n322 n323 n324 n325 n331 n332 n333 n334 n335 n336 n341 n342 n343 n344 n345 n346 n347],
      '4': %w[n421 n422 n423 n424 n431 n432 n433 n434],
      '6': %w[n623 n636],
      '8': %w[n8b1 n821 n822 n823 n824 n831 n832 n833 n834 n835 n836 n841 n842 n843 n844 n845 n846 n847 n848 n849 n851 n852 n853 n854]
    }
  }.freeze
  def initialize(name)
    @name = name.downcase
  end

  def self.now_lessons(period_data)
    if period_data[0].blank? || period_data[1].blank?
      current_time = DateTime.current
      jigen = 1
      time_period = [10.5, 12.25, 14.75, 16.5, 18.16667, 19.8334]
      time_period.each do |period|
        if current_time >= current_time.beginning_of_day + period.hours
          jigen += 1
        else
          break
        end
      end
      days = %w[a b c d e f]
      day = days[current_time.wday - 1]
      lessons = Lesson.current_year.get_by_period(jigen).get_by_period(day)
    else
      lessons = Lesson.current_year.get_by_period(period_data[0]).get_by_period(period_data[1])
    end
    lessons
  end

  # 引数は指定の時限
  # params[day,hour]の形式
  def self.blank_classrooms(period)
    lessons = ClassRoom.now_lessons(period)
    using_rooms = lessons.pluck(:classroom).uniq
    rooms = CLASS_ROOMS
    using_rooms.each do |room|
      @cr = ClassRoom.new(room)
      if @cr.name[0] != 'n'
        next if rooms[:ikebukuro][@cr.name[0].to_sym].blank?
        rooms[:ikebukuro][@cr.name[0].to_sym].delete(@cr.name)
      else
        next if rooms[:niiza][@cr.name[1].to_sym].blank?
        rooms[:niiza][@cr.name[1].to_sym].delete(@cr.name)
      end
    end
    rooms
  end
end
