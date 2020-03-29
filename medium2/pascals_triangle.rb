# Pascal's Triangle described by wikipedia, starts with n0
# n0 being the first row, with [1]
# n1 is [1 1]
# n2 is [1 2 1]
#
# For this exercise, n0 is undefined
# n1 is [1]
# n2 is [1 1]
# n3 is [1 2 1]
class Triangle
  attr_reader :rows
  def initialize(nth)
    @rows = [[1]] # n1
    @rows << [1, 1] if nth > 1
    3.upto nth, &proc { @rows << next_row } if nth > 2
  end

  private

  def next_row
    [1, *@rows.last.each_cons(2).map(&:sum), 1]
  end
end

class Triangle1
  def initialize(nth)
    @rows = [[1]] # n1
    @rows << [1, 1] if nth > 1
    3.upto nth, &grow_by_one_row if nth > 2
  end

  attr_reader :rows

  private

  def grow_by_one_row
    proc { @rows << next_row }
  end

  def next_row
    sandwhich_in_ones @rows.last.each_cons(2).map(&:sum)
  end

  def sandwhich_in_ones(ar)
    [1, *ar, 1]
  end
end
