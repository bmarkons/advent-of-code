expected_fields = [
  "byr:",
  "iyr:",
  "eyr:",
  "hgt:",
  "hcl:",
  "ecl:",
  "pid:"
]

documents = File.read("inputs/day4.txt").split("\n\n")

valid_documents_count = documents.count do |document|
  expected_fields.all? { |field| document.include?(field) }
end

puts("Total number of valid documents: #{valid_documents_count}")
