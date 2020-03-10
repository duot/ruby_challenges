

fb = (1..100).map do |n|
  next 'FizzBuzz' if n % 15 == 0
  next 'Fizz' if n % 3 == 0
  next 'Buzz' if n % 5 == 0
  n
end

# puts fb

(1..100).each do |n|
  v = if n % 15 == 0
    'FizzBuzz'
  elsif n % 3 == 0
    'Fizz'
  elsif n % 5 == 0
    'Buzz'
  else
    n
  end

  # print v
end

fb = (1..100).map do |n|
  acc = ""
  acc << 'Fizz' if n % 3 == 0
  acc << 'Buzz' if n % 5 == 0
  acc.empty? ? n : acc
end

print fb

fb = (1..100).map do |n|
  line = ''
  line << 'Fizz' if n % 3 == 0
  line << 'Buzz' if n % 5 == 0
  line[0] ? line : n
end

print fb
