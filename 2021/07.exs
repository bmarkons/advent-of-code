defmodule Fuel do
  def consumption(position, positions) do
    positions
    |> Stream.map(fn p ->
      distance = abs(p - position)
      1..distance |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def optimal_position(positions) do
    start = positions |> Enum.min()
    stop = positions |> Enum.max()

    start..stop
    |> Stream.map(fn i ->
      {i, consumption(i, positions)}
    end)
    |> Enum.min_by(&elem(&1, 1))
    |> IO.inspect()
    |> elem(0)
  end
end

positions =
  File.read!("inputs/07.txt")
  |> String.trim()
  |> String.split(",", trim: true)
  |> Enum.map(&String.to_integer/1)

Fuel.optimal_position(positions)
|> IO.inspect()
