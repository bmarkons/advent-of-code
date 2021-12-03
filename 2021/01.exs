defmodule Solution do
  def count_depth_measurement_increases(input, count \\ 0)

  def count_depth_measurement_increases(input, count) when length(input) < 2, do: count

  def count_depth_measurement_increases(input, count) do
    previous = input |> hd()
    next = input |> tl() |> hd()

    count =
      if next > previous do
        count + 1
      else
        count
      end

    input
    |> tl()
    |> count_depth_measurement_increases(count)
  end

  def windows(input, sums \\ [])

  def windows(input, sums) when length(input) < 3, do: sums

  def windows([first | [second | [third | tail]]], sums) do
    sum = first + second + third
    windows([second | [third | tail]], [sum | sums])
  end
end

File.read!("input.txt")
|> String.split()
|> Enum.map(fn string -> String.to_integer(string) end)
|> Solution.windows()
|> Enum.reverse()
|> Solution.count_depth_measurement_increases()
|> IO.inspect()
