module BookingsHelper
  def interval(time_slot)
    "#{time_slot.from}–#{time_slot.to}"
  end

  def date_and_time(booking)
    "#{booking.date} #{interval(booking.time_slot)}"
  end

  def serving_period_interval(booking_period)
    "#{booking_period.starts_at}–#{booking_period.ends_at}"
  end

  def booking_period_interval(booking_period)
    "#{booking_period.booking_starts_at}–#{booking_period.booking_ends_at}"
  end
end
