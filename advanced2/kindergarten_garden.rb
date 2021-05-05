require 'pry'

module Kindergarten
  DEFAULT_CHILDREN = %w[Alice Bob Charlie David Eve Fred Ginny Harriet Ileana Joseph Kincaid Larry]
end

=begin 
12 students
4 cups per child
2 cups per row

there are 12 students
  -they are also method names

students/cups in alphaptical order

new: takes a diagram, students = default list

query name -> plants
  left right top row
  left right bottom row

  plant index



store the diagram, split into 2 rows

eg row = vc rr gv rg
nth child n -> nth column group
  0 -> [row[0], row[1]] -> vc
  1 -> [row[2], row[3]] -> rr

group: row -> row split into pairs

garden.alice
  students index of alice -> 0

  [
  group1[0] -> vc
  group2[0] -> rr
]

garden.alice
  method_missing
    index? = students index of alice
    otherwise super

  


=end
class Garden
  def initialize(diagram, students = Garden::DEFAULT_CHILDREN)
    row1, row2 = diagram.split "\n"
    @row1 = group_in_pairs(convert_to_sym(row1))
    @row2 = group_in_pairs(convert_to_sym(row2))
    @students = students.sort
  end

  def method_missing(symbol, *args)
    maybe_name = symbol.to_s.capitalize
    return super unless (student_index = @students.index(maybe_name))

    plants(student_index)
  end

  private

  PLANTS = { "C" => :clover, "G" => :grass, "R" => :radishes, "V" => :violets }
  DEFAULT_CHILDREN = %w[Alice Bob Charlie David Eve Fred Ginny Harriet Ileana Joseph Kincaid Larry]

  def plants(child_index)
    [*@row1[child_index], *@row2[child_index]]
  end

  def convert_to_sym(plant_codes)
    plant_codes.split('').map(&::Garden::PLANTS)
  end

  def group_in_pairs(plant_arr)
    plant_arr.each_slice(2).to_a
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Garden.new "RR\nRR"
  binding.pry
end