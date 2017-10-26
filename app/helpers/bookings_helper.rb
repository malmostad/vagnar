module BookingsHelper
  def interval(time_slot)
    "#{time_slot.from}–#{time_slot.to}"
  end

  def date_and_time(booking)
    "#{booking.date} #{interval(booking.time_slot)}"
  end
end
