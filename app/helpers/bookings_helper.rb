module BookingsHelper
  def date_and_time_slot(booking)
    "#{hash.from}–#{hash.to}"
  end
end
