# frozen_string_literal: true

require 'pry'

#  a class that formats and validates phone numbers
#  bad if less than 10
#  good if 10
#  if 11, if first is 1, trim
#  if 11, if ifrst is not 1, bad
#  if more than 11, bad
#  if contains letters, bad

#  if bad, format to 0000s
class PhoneNumber
  attr_reader :number
  def initialize(number_string)
    @number = clean(number_string)
  end

  def area_code
    number[0...3]
  end

  def to_s
    number.gsub(/(...)(...)(....)/, '(\1) \2-\3')
  end

  private

  def clean(input_string)
    letters, numbers = [/[A-z]/, /\d/].map { |m| input_string.scan m }

    return '0000000000' if letters.any? ||
                           numbers[-12] ||
                           (numbers[-11] != '1' if numbers[-11]) ||
                           numbers[-10].nil?

    numbers[-10..-1].join
  end
end
