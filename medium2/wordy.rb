require 'pry'
T = ->x { binding.pry }

class WordProblem
  OPERATOR = {
    'plus' => :+, 'minus' => :-, 'multiplied' => :*, 'divided' => :/
  }.freeze

  def initialize(question)
    words = question.scan(/-?\d+|plus|minus|multiplied|divided/)
    @arithmetic = words.map(&method(:substitute_number))
                       .map(&method(:substitute_word))
    validate_size
  end

  def answer
    result, *rest = @arithmetic
    rest.each_slice(2).reduce(result) do |result, (msg, obj)|
      result.public_send msg, obj
    end
  end

  private

  def substitute_number(maybe_num)
    maybe_num.to_i.to_s == maybe_num ? maybe_num.to_i : maybe_num
  end

  def substitute_word(token)
    return token unless token.is_a? String
    OPERATOR[token]
  end

  def validate_size
    raise ArgumentError unless @arithmetic.size >= 3
  end
end

__END__
# divides the question in to relevant words
# starting with the first, reduces each successive pair
# with send 
class WordProblem
  def initialize(question)
    words = question.gsub(/What is /, '').delete('?')
                    .split # /(-?\d+)|([\D\s]+)/
    @arithmetic = words.map(&method(:substitute_number))
                       .map(&method(:substitute_word)).compact
  end

  def answer
    result, *rest = @arithmetic
    rest.each_slice(2) do |msg, obj|
      result = result.send msg, obj
    end
    result
  end

  def substitute_number(maybe_num)
    maybe_num.to_i.to_s == maybe_num ? maybe_num.to_i : maybe_num
  end

  def substitute_word(token)
    return nil if token == '' || token == 'by'
    return token unless token.is_a? String

    table = {
      'plus' => :+,
      'minus' => :-,
      'multiplied' => :*,
      'divided' => :/
    }

    table.fetch(token.strip) { raise ArgumentError }
  end
end
