defmodule Risk do
  def multiply_three_largest_basins(points, map) do
    points
    |> Enum.map(&basin(&1, map))
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.take(-3)
    |> Enum.reduce(1, &(elem(&1, 0) * &2))
  end

  def basin(point, map, counter \\ 0, counted \\ []) do
    counter = counter + 1
    counted = [point | counted]

    higher_neighbours(point, map)
    |> Enum.reduce({counter, counted}, fn neighbour, {counter, counted} ->
      if(!Enum.member?(counted, neighbour)) do
        basin(neighbour, map, counter, counted)
      else
        {counter, counted}
      end
    end)
  end

  def higher_neighbours({i, j}, map) do
    i_max = length(map) - 1
    j_max = length(hd(map)) - 1
    current = map |> Enum.at(i) |> Enum.at(j)

    left =
      if j == 0 do
        -1
      else
        map |> Enum.at(i) |> Enum.at(j - 1)
      end

    right =
      if j == j_max do
        -1
      else
        map |> Enum.at(i) |> Enum.at(j + 1)
      end

    top =
      if i == 0 do
        -1
      else
        map |> Enum.at(i - 1) |> Enum.at(j)
      end

    bottom =
      if i == i_max do
        -1
      else
        map |> Enum.at(i + 1) |> Enum.at(j)
      end

    [{left, {i, j - 1}}, {top, {i - 1, j}}, {right, {i, j + 1}}, {bottom, {i + 1, j}}]
    |> Enum.filter(&(elem(&1, 0) > current && elem(&1, 0) < 9))
    |> Enum.map(&elem(&1, 1))
  end

  def get_starting_positions(map) do
    for i <- 0..(length(map) - 1) do
      for j <- 0..(length(hd(map)) - 1) do
        current = map |> Enum.at(i) |> Enum.at(j)

        if current < lowest_neighbour(map, i, j) do
          {i, j}
        end
      end
    end
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
  end

  def lowest_neighbour(map, i, j) do
    i_max = length(map) - 1
    j_max = length(hd(map)) - 1

    left =
      if j == 0 do
        :infinity
      else
        map |> Enum.at(i) |> Enum.at(j - 1)
      end

    right =
      if j == j_max do
        :infinity
      else
        map |> Enum.at(i) |> Enum.at(j + 1)
      end

    top =
      if i == 0 do
        :infinity
      else
        map |> Enum.at(i - 1) |> Enum.at(j)
      end

    bottom =
      if i == i_max do
        :infinity
      else
        map |> Enum.at(i + 1) |> Enum.at(j)
      end

    [left, right, top, bottom] |> Enum.min()
  end
end

map =
  File.read!("inputs/09.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, "", trim: true))
  |> Enum.map(&Enum.map(&1, fn n -> String.to_integer(n) end))

map
|> Risk.get_starting_positions()
|> Risk.multiply_three_largest_basins(map)
|> IO.inspect()
