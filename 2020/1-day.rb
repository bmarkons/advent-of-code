input = input.map { |i| i.to_i }

input.each do |i|
  input.each do |j|
    if (i + j) == 2020
      puts i * j
    end
  end
end

input.each do |i|
  input.each do |j|
    input.each do |k|
      if (i + j + k) == 2020
        puts i * j * k
      end
    end
  end
end
