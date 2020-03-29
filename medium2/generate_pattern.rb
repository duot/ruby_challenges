def generate_pattern(n)
  nth_row = [*'1'..n.to_s].join
  size = nth_row.size
  i = 1
  loop do
    puts [*'1'..i.to_s].join.ljust size, '*'
    break if i == n
    i += 1
  end
end

if __FILE__ == $0
  puts generate_pattern(20)
end