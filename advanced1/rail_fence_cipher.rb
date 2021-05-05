require 'pry'

# =begin
# encoding:
# the message is written up or down on a fence
#   direction alternates, zigzags
#   how?
#     zig = Zigzag.new nrails, strlen
#     zig.fill_zig plaintext
#   letters is read in rows
#     rows of the lines, 
#       a row is a collection of every nth element in the zigzag
#         for downward:
#           simply nth element
#       for upward fence, 
#           the fence reversed, and padded with empty elements
#           then, nth element
#     iterate 0...nrails
#       zig.read_row n
# decoding:
#   "take the zigzag shape, then fill the cipher along the rows"
#   how many lines are needed?
#     based on nrails, and strlen
#   how?
#     zig = Zigzag.new nrails, strlen
#     ce = cipher.enum
#     iterate 0...n
#       zig.fill_row n, ce
#     the plaintext is read from the zigzag:
#       read downwards, then upwards, then down, etc
#         fence.to_s where fence is up | down
#           down is simpley chars.join
#           up chars.compact.reverse.join
#     zig.read_zig
# =end
class RailFenceCipher
  class << self
    def encode(plaintext, nrails)
      z = Zigzag.new nrails, plaintext.size
      z.fill_zig! plaintext.chars
      z.rows.join
    end

    def decode(ciphertext, nrails)
      z = Zigzag.new nrails, ciphertext.size
      chars = ciphertext.chars
      (0...nrails).each do |row|
        z.fill_row! row, chars 
      end

      z.read_zig
    end
  end
end

# =begin
# zig.new nrails, strlen
#   lines = []
#   s = strlen
#   up_alternate = [false, true].cycle
#   while s > nrails
#     s -= nrails
#     fence.new up_alternate.next, s
#
#   if s > 0
#     lines << fence.new up_alternate, s
#
# zig.lines
# zig.fill_row n, cipher_enum
#   lines.each fence
#     fence[n] = cipher_enum.next
#
#
# zig.read_row
#
# zig.fill_zig(plain)
#   plaintext :> void
#   lines.each |fence|
#     fence.fill plain_enum
#
# zig.read_zig
# =end
class RailFenceCipher::Zigzag
  attr_reader :lines, :text_length, :nrails

  def initialize(nrails, text_length)
    @nrails = nrails
    @text_length = text_length
    setup_lines
  end

  def fill_zig!(str_arr)
    lines.each do |fence| 
      filled_some = fence.fill!(str_arr)
      break unless filled_some
    end

    raise StandardError, "There's chars not used" if !str_arr.empty?
  end

  def read_zig
    lines.join
  end

  def fill_row!(row, str_arr)
    lines.each { |fence| fence.fill_1! row, str_arr }
  end

  def read_row(index)
    lines.map { |fence| fence[index] }.join
  end

  def rows
    (0...@nrails).map { |row| read_row(row) }
  end

  private
  def setup_lines
    lines = []
    chars_left = @text_length
    direction_cycle = [false, true].cycle

    max_number_of_chars = { true => nrails >= 3 ? nrails - 2 : 0,
                          false => nrails }

    chars_left = @text_length
    while chars_left > 0 
      upwards = direction_cycle.next
      line_length = max_number_of_chars[upwards]
      next if upwards && nrails < 3

      lines << Line.new(upwards, nrails, line_length)
      chars_left -= line_length
    end

    @lines = lines
  end
end

# =begin
# new(up?, number_of_chars)
#
# fence.fill enum
#   n = number_of_chars
#   loop 
#       @chars << enum.next
#     n -= 1
#     break if n <= 0
#
# fill!
#   downwards, will fill 1..n rails
#     or 1..content length, where content len is <= nrails

#   upwards, 
#     has at most length of nrails - 2
#       will fill some if nrails is 3 or more
#
#     will fill 1..n-2 chars or less
#
# [](index)
#   if up?
#     if @reversed
#       @reversed[index]
#     else
#       @reversed = @chars.reverse.unshift nil
#   else
#     @chars[index]
#
# =end
class RailFenceCipher::Zigzag::Line
  def initialize(upwards, max_length, content_length)
    @upwards = upwards
    @max_length = max_length
    @content_length = content_length
    @chars = []
  end

  def fill!(str_arr)
    if (chars = str_arr.shift @content_length)
      @chars = @upwards ? chars.reverse.unshift(nil) : chars
    end
  end

  def fill_1!(row, str_arr)
    if @upwards && (row == 0 || row == @max_length - 1)
      @chars << nil
      return
    end

    return if @chars.compact.size == @content_length

    @chars << str_arr.shift 
  end

  def [](index)
    @chars[index]
  end

  def to_s
    @upwards ? @chars.reverse.join : @chars.join
  end
end

if __FILE__ == $PROGRAM_NAME
  # e = RailFenceCipher.encode("WEAREDISCOVEREDFLEEATONCE", 3)
  # d = RailFenceCipher.decode("WECRLTEERDSOEEFEAOCAIVDEN", 3)

  empty = RailFenceCipher.encode("", 4)
  one = RailFenceCipher.encode("one rail", 1)
  # chars = "asdf".chars
  # l = RailFenceCipher::Zigzag::Line.new false, 3, 2
  # # l.fill_1! 0, chars

  # u = RailFenceCipher::Zigzag::Line.new true, 3, 2

  binding.pry
end