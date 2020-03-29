require 'pry'
class Bst
  attr_reader :data, :left, :right

  def initialize(data)
    @data = data
  end

  def each(&block)
    [*left&.each, data, *right&.each].each &block
  end

  def insert(new_data)
    new_data > data ? insert_right(new_data) : insert_left(new_data)
  end

  private

  def insert_left(new_data)
    left ? left.insert(new_data) : @left = self.class.new(new_data)
  end

  def insert_right(data)
    right ? right.insert(data) : @right = self.class.new(data)
  end
end
