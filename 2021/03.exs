defmodule Solution do
  def filter_by(input, at, fun) when length(input) < 2 do
    hd(input)
    |> Enum.reverse()
    |> decimal()
  end

  def filter_by(input, at, fun) do
    grouped_by =
      input
      |> Enum.group_by(&Enum.at(&1, at))

    input = fun.(grouped_by)
    filter_by(input, at + 1, fun)
  end

  def decimal(bitlist) do
    bitlist
    |> Enum.reduce({0, 0}, fn bit, {decimal, power} ->
      bit = String.to_integer(bit)
      {decimal + bit * :math.pow(2, power), power + 1}
    end)
    |> elem(0)
  end
end

input =
  File.read!("inputs/test.txt")
  |> String.split()
  |> Enum.map(fn code -> String.split(code, "", trim: true) end)

oxygen =
  input
  |> Solution.filter_by(0, fn grouped_by ->
    with_zeros = grouped_by["0"]
    with_ones = grouped_by["1"]

    zeros_count = Enum.count(grouped_by["0"] || [])
    ones_count = Enum.count(grouped_by["1"] || [])

    cond do
      zeros_count > ones_count ->
        with_zeros

      zeros_count < ones_count ->
        with_ones

      true ->
        with_ones
    end
  end)
  |> IO.inspect()

co2 =
  input
  |> Solution.filter_by(0, fn grouped_by ->
    with_zeros = grouped_by["0"]
    with_ones = grouped_by["1"]

    zeros_count = Enum.count(grouped_by["0"] || [])
    ones_count = Enum.count(grouped_by["1"] || [])

    cond do
      zeros_count < ones_count ->
        with_zeros

      zeros_count > ones_count ->
        with_ones

      true ->
        with_zeros
    end
  end)
  |> IO.inspect()

IO.puts(co2 * oxygen)
