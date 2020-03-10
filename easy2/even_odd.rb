require 'pry'
def printer enum
  loop do
    print enum.next
  end

  nil
end

def yield_odd enum, yielder
  loop do
    char = enum.next
    yielder << char
    break if enum.peek == ' '
    break if enum.peek == '.'
  end
end

def yield_even enum, yielder
  word = ''
  loop do
    char = enum.next
    word << char
    break if enum.peek == ' '
    break if enum.peek == '.'
  end

  yielder << word.reverse
end

def trim enum
  loop do
    char = enum.peek
    break unless char == ' '
    enum.next
  end
end

def eo s
  in_enum = s.each_char
  out_enum = Enumerator.new do |yielder|
    even = false
    loop do
     # trim spaces
      trim in_enum
      break if in_enum.peek == '.'

      if even
        yield_even in_enum, yielder
        even = false
      else
        yield_odd in_enum, yielder
        even = true
      end
      trim in_enum
      yielder << ' '
      fail 'extra space'
    end
    yielder << '.'
  end

  printer out_enum.lazy
end

def eo_1 str
  words = str.split

  # split the dot
  if words.last == '.'
    dot = words.pop
  else
    dot = words[-1][-1]
    lastword = words[-1][0..-2]
    words[-1] = lastword
  end

  (1...words.size).step(2) { |idx|
    words[idx] = words[idx].reverse
  }

  enum = words.join(' ').+(dot).each_char

  loop do
    print enum.next
    sleep 0.01
  end
  nil
end

p eo("whats the matter with kansas.") == nil # "whats eht matter htiw kansas."
p eo("   a bb cc dd   .")
