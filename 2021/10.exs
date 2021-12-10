defmodule Syntax do
  @table %{
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">"
  }

  def find_closing(line) do
    left_openings =
      line
      |> String.split("", trim: true)
      |> Enum.reduce_while([], fn c, stack ->
        if opening?(c) do
          {:cont, [c | stack]}
        else
          if @table[hd(stack)] == c do
            {:cont, tl(stack)}
          else
            {:halt, false}
          end
        end
      end)

    left_openings
    |> Enum.map(fn opening ->
      @table[opening]
    end)
  end

  def check(line) do
    line
    |> String.split("", trim: true)
    |> Enum.reduce_while([], fn c, stack ->
      if opening?(c) do
        {:cont, [c | stack]}
      else
        if @table[hd(stack)] == c do
          {:cont, tl(stack)}
        else
          {:halt, false}
        end
      end
    end)
  end

  def opening?(character) do
    @table |> Map.keys() |> Enum.member?(character)
  end

  def calculate_points(character) do
    case character do
      ")" -> 1
      "]" -> 2
      "}" -> 3
      ">" -> 4
    end
  end
end

result =
  File.read!("inputs/10.txt")
  |> String.split("\n", trim: true)
  |> Stream.filter(fn line ->
    Syntax.check(line)
  end)
  |> Enum.map(fn line ->
    Syntax.find_closing(line)
  end)
  |> Enum.map(fn line ->
    line
    |> Enum.reduce(0, fn c, score ->
      score * 5 + Syntax.calculate_points(c)
    end)
  end)
  |> Enum.sort()
  |> IO.inspect()

middle = div(length(result), 2) |> IO.inspect()
result |> Enum.at(middle) |> IO.inspect()
