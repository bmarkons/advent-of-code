defmodule S do
  def digits(input) do
    [words | [to_calculate | _]] =
      input
      |> String.split(" | ", trim: true)

    to_calculate = to_calculate |> String.split(" ", trim: true)

    words = words |> String.split(" ", trim: true)

    # find 1, 7, 4, 8
    m =
      words
      |> Enum.group_by(fn word ->
        cond do
          l(word) == 2 -> [1]
          l(word) == 3 -> [7]
          l(word) == 4 -> [4]
          l(word) == 5 -> [2, 3, 5]
          l(word) == 6 -> [6, 9, 0]
          l(word) == 7 -> [8]
        end
      end)

    # find 3
    [a | [b | [c | _]]] = m[[2, 3, 5]]

    ab = diff(a, b)
    ac = diff(a, c)
    bc = diff(b, c)

    three =
      cond do
        ab == ac -> a
        ab == bc -> b
        ac == bc -> c
      end

    m =
      m
      |> Map.put([3], [three])
      |> Map.put([2, 5], m[[2, 3, 5]] -- [three])
      |> Map.delete([2, 3, 5])

    # find 2 and 5

    [a | [b | _]] = m[[2, 5]]

    [four | _] = m[[4]]

    {two, five} =
      if(diff(a, four) == 2) do
        {b, a}
      else
        {a, b}
      end

    m =
      m
      |> Map.put([2], [two])
      |> Map.put([5], [five])
      |> Map.delete([2, 5])

    # find 9

    [four | _] = m[[4]]
    [a | [b | [c | _]]] = m[[6, 9, 0]]

    nine =
      cond do
        diff(a, four) == 2 -> a
        diff(b, four) == 2 -> b
        diff(c, four) == 2 -> c
      end

    m =
      m
      |> Map.put([9], [nine])
      |> Map.put([6, 0], m[[6, 9, 0]] -- [nine])
      |> Map.delete([6, 9, 0])

    # find 6 and 0

    [one | _] = m[[1]]
    [a | [b | _]] = m[[6, 0]]

    {six, zero} =
      if diff(a, one) == 4 do
        {b, a}
      else
        {a, b}
      end

    m =
      m
      |> Map.put([6], [six])
      |> Map.put([0], [zero])
      |> Map.delete([6, 0])

    to_calculate
    |> Enum.map(fn w ->
      find_digit(m, w)
    end)
    |> Enum.join("")
    |> String.to_integer()
  end

  def find_digit(map, word) do
    {[k | _], _} =
      map
      |> Enum.find(fn {_, [v | _]} ->
        l(v) == l(word) && String.to_charlist(v) -- String.to_charlist(word) == []
      end)

    "#{k}"
  end

  def l(x) do
    String.length(x)
  end

  def diff(a, b) do
    (String.split(a, "", trim: true) -- String.split(b, "", trim: true)) |> Enum.count()
  end
end

File.read!("inputs/08.txt")
|> String.split("\n", trim: true)
|> Enum.map(fn line ->
  S.digits(line)
end)
|> Enum.sum()
|> IO.inspect()
