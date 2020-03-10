require 'minitest/autorun'
require_relative 'luhn'

class LuhnTest < Minitest::Test
  def test_addends
    luhn = Luhn.new(12_121)
    assert_equal [1, 4, 1, 4, 1], luhn.addends
  end

  def test_addend1111
    luhn = Luhn.new 1111
    assert_equal [2, 1, 2, 1], luhn.addends
  end

  def test_addend8763
    luhn = Luhn.new 8763
    assert_equal [7, 7, 3, 3], luhn.addends
  end

  def test_too_large_addend
    luhn = Luhn.new(8631)
    assert_equal [7, 6, 6, 1], luhn.addends
  end

  def test_checksum1111
    luhn = Luhn.new(1111)
    assert_equal 6, luhn.checksum
  end

  def test_checksum
    luhn = Luhn.new(8763)
    assert_equal 20, luhn.checksum
  end

  def test_checksum
    luhn = Luhn.new(4913)
    assert_equal 22, luhn.checksum
  end

  def test_checksum_again
    luhn = Luhn.new(201_773)
    assert_equal 21, luhn.checksum
  end

  def test_invalid_number
    luhn = Luhn.new(738)
    refute luhn.valid?
  end

  def test_invalid2323_2005_7766_355
    luhn = Luhn.new 2323_2005_7766_355
    refute luhn.valid?
  end

  def test_valid2323_2005_7766_3554
    luhn = Luhn.new 2323_2005_7766_3554
    assert luhn.valid?
  end

  def test_valid_2323200577663554
    luhn = Luhn.new 2323200577663554
    assert luhn.valid?
  end

  def test_valid_number
    luhn = Luhn.new(8_739_567)
    assert luhn.valid?
  end

  def test_create_valid_number
    number = Luhn.create(123)
    assert_equal 1230, number
  end

  def test_create_other_valid_number
    number = Luhn.create(873_956)
    assert_equal 8_739_567, number
  end

  def test_create_yet_another_valid_number
    number = Luhn.create(837_263_756)
    assert_equal 8_372_637_564, number
  end
end
