module ClassRoomHelper
  def now_jigen
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

    jigen
  end
end
