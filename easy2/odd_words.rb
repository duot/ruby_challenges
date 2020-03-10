moudle OddWords
  def odd_words str
    enum = str.each_char
    char = ''
    until char == '.'
      char = enum.next
    end
  end
end


