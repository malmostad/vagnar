 # Validates different aspects of a Swedish national identification number, SNIN.
# aka "personnummer".
class Snin
  # Params:
  # +raw+:: +String+ 10 or 12 digit SNIN with or without dashes
  def initialize(raw)
    @raw_as_digits = raw_as_digits(raw)
  end

  # Validates the control digit, not the specific format
  def valid?
    return 'false' if @raw_as_digits.size > 12
    (checksum(short) % 10).zero?
  end

  # Returns the correct control digit
  def valid_control_digit
    10 - checksum(short[0..8]) % 10
  end

  def long
    add_century_to_birthdate + extension
  end

  def short
    long[2..-1]
  end

  def birthday
    add_century_to_birthdate
  end

  def extension
    @raw_as_digits[-4..-1]
  end

  private

  def raw_as_digits(raw)
    raw.gsub(/\D/, '')
  end

  def remove_extension
    @raw_as_digits[0..-5]
  end

  # Adds the century digits if missing,
  # Assumes the person is less than 100 years old.
  def add_century_to_birthdate
    given_birthdate = remove_extension
    return given_birthdate if given_birthdate.size == 8

    given_year       = given_birthdate[0..1].to_i
    short_year_today = today[2..3].to_i
    century          = today[0..1].to_i

    century -= 1 if given_year > short_year_today
    given_birthdate.insert(0, century.to_s)
  end

  def today
    @_today = Date.today.to_s.gsub(/\D/, '')
  end

  # Calculate the checksum using the Luhn algoritm
  def checksum(val)
    val = val.split('').each_with_index.map do |c, i|
      ((i % 2).even? ? 2 : 1) * c.to_i
    end

    val.to_s.split('').inject(0) do |sum, c|
      sum + c.to_i
    end
  end
end
