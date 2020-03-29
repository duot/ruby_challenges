class SimpleLinkedList
  ::Element = Struct.new :datum, :next do
    def tail?
      !self.next
    end
  end

  def self.from_a(arr)
    list = new
    (arr || []).reverse.each { |el| list.push el }
    list
  end

  attr_reader :head, :size
  def initialize
    @size = 0
    @head = nil
  end

  def push(datum)
    @head = Element.new(datum, head)
    @size += 1
  end

  def pop
    datum, @head = head.datum, head.next
    @size -= 1
    datum
  end

  def peek
    head&.datum
  end

  def empty?
    !head
  end

  def reverse(container = self.class.new)
    container.push pop until empty?
    container
  end

  def to_a
    reverse []
  end
end
