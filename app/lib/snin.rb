 # Validates different aspects of a Swedish national( identification number )(SNIN)
# aka "personnummer".
# Takes both 10 and 12 digits with and without a dash for validation.
#
# ==== Examples:
#    snin = Snin.new('19700101-1233')
#    puts snin.valid? # => true
#    puts snin.valid_control_digit # => 3
#    puts snin.valid_birthdate? # => true
#    puts snin.years_old # => Some int
#
#    snin = Snin.new('700101-1233')
#    puts snin.to_long # => "19700101-1233"
#    puts snin.valid_format?(false, true) # => true
#
class Snin
  # Params:
  # +snin+:: +String+ 10 or 12 digit SNIN with or without a dash
  def initialize(snin)
    @raw = snin.to_s
    @plain = plain
  end

  # Validates the control digit, not the specific format
  def valid?
    to_short.size == 10 && (checksum(to_short) % 10).zero?
  end

  # Validates the format given
  # with_century Boolean  True if it must be 12 digit, false if 10
  # with_dash Boolean  True if it must contain a dash before the last 4 digits
  def valid_format?(with_century = false, with_dash = true)
    date = with_century ? '\d{8}' : '\d{6}'
    separator = with_dash ? '-' : ''
    @raw.match(/\A#{date}#{separator}\d{4}\z/).present?
  end

  # Returns the correct control digit
  def valid_control_digit
    10 - checksum(to_short[0..8]) % 10
  end

  # Is the date given valid?
  def valid_birthdate?
    to_date
  end

  def plain
    to_long.remove(/\D/)
  end

  # Returns the DateTime object for the given SNIN or false if not a valid date format
  def to_date
    begin
      @plain.to_date
    rescue
      false
    end
  end

  # Returns the age of the person as an integer
  # Assume that the person is < 100 if SNIN is in short form
  def years_old
    now = Date.today
    birthday = to_date
    now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
  end

  # Is the SNIN in long (12 digits) or short (10 digits) form?
  def short_or_long
    remove_dash(@raw).size == 12 ? 'long' : 'short'
  end

  # Is the SNIN on long (12 digits) form?
  def long?
    short_or_long == 'long'
  end

  # Is the SNIN on short (10 digits) form?
  def short?
    short_or_long == 'short'
  end

  def to_short
    remove_century(remove_dash(@raw))
  end

  # Adds the 2 century digits if given a short format Snin,
  # assumes the person is less than 100 years old.
  def to_long
    return @raw if remove_dash(@raw).size == 12
    century = Date.today
    @raw.to_s.gsub(/\D/, '').insert 0, century.to_s
  end

  # Removed the century digits if given in long form
  def remove_century(val)
    val.length == 12 ? val[2..-1] : val
  end

  # Add dash before the last 4 digits if missing
  def add_dash(val)
    remove_dash(val).insert -5, "-"
  end

  # Rempoves any non digit in the string
  def remove_dash(val)
    val.to_s.gsub(/\D/, '')
  end

  private

  # Calculate the checksum using the Luhn algoritm
  def checksum(val)
    val.split(//).enum_for(:each_with_index).map do |c, i|
      ((i % 2).even? ? 2 : 1) * c.to_i
    end.to_s.split(//).inject(0) { |sum, c| sum += c.to_i }
  end
end
