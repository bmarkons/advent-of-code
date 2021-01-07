class Map
  @matrix = nil
  @current_row = nil
  @current_column = nil
  @tree_counter = nil

  def initialize(move = "move1down3right")
    input = File.read("inputs/day3.txt")

    @move = move
    @matrix = input.split("\n").map { |line| line.chars }
    @current_row = 0
    @current_column = 0
    @rows = @matrix.size
    @columns = @matrix[0].size
    @tree_counter = 0
  end

  def run_to_bottom
    while not bottom? do
      send(@move)
      @tree_counter += 1 if tree?
    end
  end

  def move1down3right
    @current_row += 1
    @current_column = (@current_column + 3) % @columns
  end

  def move1down1right
    @current_row += 1
    @current_column = (@current_column + 1) % @columns
  end

  def move1down5right
    @current_row += 1
    @current_column = (@current_column + 5) % @columns
  end

  def move1down7right
    @current_row += 1
    @current_column = (@current_column + 7) % @columns
  end

  def move2down1right
    @current_row += 2
    @current_column = (@current_column + 1) % @columns
  end

  def bottom?
    @current_row == (@matrix.size - 1)
  end

  def tree?
    @matrix[@current_row][@current_column] == "#"
  end

  def tree_counter
    @tree_counter
  end
end

maps = [
  m1 = Map.new("move1down3right"),
  m2 = Map.new("move1down1right"),
  m3 = Map.new("move1down5right"),
  m4 = Map.new("move1down7right"),
  m5 = Map.new("move2down1right")
]

tree_counter_values =
  maps
  .each { |map| map.run_to_bottom }
  .map { |map| map.tree_counter }

puts "The result is #{tree_counter_values.reduce(:*)}"

