# Processes single line of the input
def valid?(policy)
  match_data = /(\d+)-(\d+) ([a-zA-Z]): ([a-zA-Z]+)/.match(policy)
  position1 = match_data[1].to_i
  position2 = match_data[2].to_i
  char = match_data[3]
  str = match_data[4]

  puts "Looking for #{char} at position #{position1}..."
  is_char_at_position_1 = (str[position1 - 1] == char)
  puts is_char_at_position_1

  puts "Looking for #{char} at position #{position2}..."
  is_char_at_position_2 = (str[position2 - 1] == char)
  puts is_char_at_position_2

  puts "Checking whether the character is at the both positions..."
  are_same_chars_at_both_positions = (is_char_at_position_1 == is_char_at_position_2)
  puts are_same_chars_at_both_positions

  return (is_char_at_position_1 || is_char_at_position_2) && !are_same_chars_at_both_positions
end

# Takes the whole input and counts valid policies
def count_valid_policies(input)
  policies = input.split("\n")
  policies.count { |policy| valid?(policy) }
end

def run
  input = File.read("./inputs/day2.txt")
  result = count_valid_policies(input)
  puts "The result is #{result}"
end

def debug
  policy = ARGV[0]
  result = valid?(policy)
  puts "The policy is #{result} valid"
end

run
