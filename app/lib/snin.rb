 # Validates different aspects of a Swedish national identification number, SNIN.
# aka "personnummer".
# Takes 10 or 12 digits with or without dashes
#
# ==== Examples:
#    snin = Snin.new('19700101-1233')
#    snin.valid? # => true
#    snin.valid_control_digit # => 3
#    snin.years_old # => Some int
#
#    snin = Snin.new('700101-1233')
#    snin.add_century # => "19700101-1233"
#    snin.valid_format?(false, true) # => true
#
class Snin
  # Params:
  # +snin+:: +String+ 10 or 12 digit SNIN with or without a dashes
  def initialize(snin)
    @raw = snin.to_s
    @plain = plain
  end

  # Validates the control digit, not the specific format
  def valid?
    to_short.size == 10 && (checksum(to_short) % 10).zero?
  end

  # Validates the format
  #   param with_century Boolean  True if it must be 12 digit, false if 10
  #   param with_dash Boolean  True if it must contain a dash before the last 4 digits
  def valid_format?(with_century = false, with_dash = true)
    date = with_century ? '\d{8}' : '\d{6}'
    separator = with_dash ? '-' : ''
    @raw.match(/\A#{date}#{separator}\d{4}\z/).present?
  end

  # Returns the correct control digit
  def valid_control_digit
    10 - checksum(to_short[0..8]) % 10
  end

  def plain
    add_century
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

  # Adds the century digits if missing,
  # Assumes the person is less than 100 years old.
  def add_century
    raw = @raw.to_s.gsub(/\D/, '')
    birth_date = raw[0..8].to_s

    return birth_date if raw.size == 12

    short_given_year = birth_date[0..1].to_i
    today            = Date.today.to_s
    short_year_today = today[2..3].to_i
    century          = today[0..1].to_i

    century -= 1 if short_given_year > short_year_today

    raw.insert 0, century.to_s
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
