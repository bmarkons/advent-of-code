defmodule Submarine do
  def step(map, flash_count) do
    {new_map, current_step_flash_count, _} =
      map
      |> increase_energies()
      |> flash()

    {new_map, flash_count + current_step_flash_count}
  end

  def increase_energies(map) do
    map
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn energy ->
        energy + 1
      end)
    end)
  end

  def flash(map) do
    1..1_000_000_000_000
    |> Enum.reduce_while({map, 0, []}, fn _, {map, flash_count, flashed} ->
      {map, count, flashed} = map |> count_and_flash(flashed)

      if count > 0 do
        {:cont, {map, flash_count + count, flashed}}
      else
        {:halt, {map, flash_count, flashed}}
      end
    end)
  end

  def count_and_flash(map, flashed) do
    # extract position of octopuses with energies above 9
    positions =
      for i <- 0..(length(map) - 1) do
        for j <- 0..(length(hd(map)) - 1) do
          current = map |> Enum.at(i) |> Enum.at(j)

          if current > 9 do
            {i, j}
          end
        end
      end
      |> List.flatten()
      |> Enum.reject(&is_nil/1)

    flashed = flashed ++ positions

    # set energy to 0 for each octopus which flashed
    map =
      for i <- 0..(length(map) - 1) do
        for j <- 0..(length(hd(map)) - 1) do
          current = map |> Enum.at(i) |> Enum.at(j)

          if current > 9 do
            0
          else
            current
          end
        end
      end

    # for each octopus which flashed find neighbours which haven't flashed yet
    neighbours =
      positions
      |> Enum.map(fn position ->
        neighbours(position, length(map) - 1, length(hd(map)) - 1)
      end)
      |> List.flatten()
      |> Enum.filter(fn p -> !Enum.member?(flashed, p) end)

    # increase energies of neighbours octopuses
    map =
      for i <- 0..(length(map) - 1) do
        for j <- 0..(length(hd(map)) - 1) do
          current = map |> Enum.at(i) |> Enum.at(j)

          neighbours
          |> Enum.filter(&(&1 == {i, j}))
          |> Enum.reduce(current, fn _, c -> c + 1 end)
        end
      end

    {map, Enum.count(positions), flashed}
  end

  def neighbours({i, j}, i_max, j_max) do
    [
      {i + 1, j},
      {i - 1, j},
      {i, j + 1},
      {i, j - 1},
      {i - 1, j - 1},
      {i - 1, j + 1},
      {i + 1, j - 1},
      {i + 1, j + 1}
    ]
    |> Enum.filter(&limit(&1, i_max, j_max))
  end

  def limit({i, j}, i_max, j_max) do
    unless i < 0 || i > i_max || j < 0 || j > j_max do
      {i, j}
    end
  end
end

ExUnit.start()

defmodule AssertionTest do
  use ExUnit.Case

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(
      &(String.split(&1, "", trim: true)
        |> Enum.map(fn s -> String.to_integer(s) end))
    )
  end

  def step(times) do
    1..times
    |> Enum.reduce({initial_map, 0}, fn _, {map, flash_count} ->
      Submarine.step(map, flash_count)
    end)
  end

  def initial_map, do: File.read!("inputs/test.txt") |> parse()

  test "before any steps" do
    expected =
      """
      5483143223
      2745854711
      5264556173
      6141336146
      6357385478
      4167524645
      2176841721
      6882881134
      4846848554
      5283751526
      """
      |> parse()

    assert initial_map == expected
  end

  test "after step 1" do
    expected =
      """
      6594254334
      3856965822
      6375667284
      7252447257
      7468496589
      5278635756
      3287952832
      7993992245
      5957959665
      6394862637
      """
      |> parse()

    {map, count} = step(1)

    assert map == expected
  end

  test "after step 2" do
    expected =
      """
      8807476555
      5089087054
      8597889608
      8485769600
      8700908800
      6600088989
      6800005943
      0000007456
      9000000876
      8700006848
      """
      |> parse()

    {map, count} = step(2)

    assert map == expected
  end

  test "after step 3" do
    expected =
      """
      0050900866
      8500800575
      9900000039
      9700000041
      9935080063
      7712300000
      7911250009
      2211130000
      0421125000
      0021119000
      """
      |> parse()

    {map, count} = step(3)

    assert map == expected
  end

  test "after step 10" do
    expected =
      """
      0481112976
      0031112009
      0041112504
      0081111406
      0099111306
      0093511233
      0442361130
      5532252350
      0532250600
      0032240000
      """
      |> parse()

    {map, count} = step(10)

    assert map == expected
    assert count == 204
  end

  test "after step 100" do
    expected =
      """
      0397666866
      0749766918
      0053976933
      0004297822
      0004229892
      0053222877
      0532222966
      9322228966
      7922286866
      6789998766
      """
      |> parse()

    {map, count} = step(100)

    assert map == expected
    assert count == 1656
  end
end

IO.puts("----------------")

map =
  File.read!("inputs/11.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(
    &(String.split(&1, "", trim: true)
      |> Enum.map(fn s -> String.to_integer(s) end))
  )

0..1_000_000_000_000
|> Enum.reduce_while({map, 0}, fn step, {map, flash_count} ->
  if(
    map == [
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]
  ) do
    {:halt, step}
  else
    {:cont, Submarine.step(map, flash_count)}
  end
end)
|> IO.inspect()
