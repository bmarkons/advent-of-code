defmodule Bingo do
  # Transforms:
  #
  # [
  #   [
  #     ["1", "2", "3", "4", "5"],
  #     ["1", "2", "3", "4", "5"],
  #     ["1", "2", "3", "4", "5"],
  #     ["1", "2", "3", "4", "5"]
  #   ],
  #   [
  #     ["1", "2", "3", "4", "5"],
  #     ["1", "2", "3", "4", "5"],
  #     ["1", "2", "3", "4", "5"],
  #     ["1", "2", "3", "4", "5"]
  #   ]
  # ]
  #
  # To:
  #
  # [
  #   [
  #     [{"1", :unmarked}, {"2", :unmarked}, {"3", :unmarked}, {"4", :unmarked}, {"5", :unmarked}],
  #     [{"1", :unmarked}, {"2", :unmarked}, {"3", :unmarked}, {"4", :unmarked}, {"5", :unmarked}],
  #     [{"1", :unmarked}, {"2", :unmarked}, {"3", :unmarked}, {"4", :unmarked}, {"5", :unmarked}],
  #     [{"1", :unmarked}, {"2", :unmarked}, {"3", :unmarked}, {"4", :unmarked}, {"5", :unmarked}]
  #   ],
  #   [
  #     [{"1", :unmarked}, {"2", :unmarked}, {"3", :unmarked}, {"4", :unmarked}, {"5", :unmarked}],
  #     [{"1", :unmarked}, {"2", :unmarked}, {"3", :unmarked}, {"4", :unmarked}, {"5", :unmarked}],
  #     [{"1", :unmarked}, {"2", :unmarked}, {"3", :unmarked}, {"4", :unmarked}, {"5", :unmarked}],
  #     [{"1", :unmarked}, {"2", :unmarked}, {"3", :unmarked}, {"4", :unmarked}, {"5", :unmarked}]
  #   ]
  # ]
  #
  def initialize(boards) do
    boards
    |> Enum.map(fn board ->
      board
      |> Enum.map(fn row ->
        row
        |> Enum.map(fn number ->
          {number, :unmarked}
        end)
      end)
    end)
  end

  def play(boards, numbers, last_winner \\ nil, last_number \\ nil)

  def play(_boards, numbers, last_winner, last_number) when length(numbers) < 1,
    do: {last_winner, last_number}

  def play(boards, numbers, last_winner, last_number) do
    boards =
      numbers
      |> hd()
      |> mark_multiple(boards)

    winner = Enum.find(boards, &winner?(&1))

    last_winner =
      if winner do
        IO.puts("WINNER!")
        IO.inspect(winner)
        winner
      else
        last_winner
      end

    last_number =
      if winner do
        hd(numbers) |> String.to_integer()
      else
        last_number
      end

    play(boards |> Enum.reject(&winner?(&1)), tl(numbers), last_winner, last_number)
  end

  def mark_multiple(number, boards) do
    boards |> Enum.map(&mark_single(number, &1))
  end

  def mark_single(number, board) do
    board
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn el ->
        if elem(el, 0) == number do
          put_elem(el, 1, :marked)
        else
          el
        end
      end)
    end)
  end

  def winner?(board) do
    whole_row_marked?(board) || whole_column_marked?(board)
  end

  def whole_row_marked?(board) do
    board
    |> Enum.any?(fn row ->
      if length(row) > 0 do
        row
        |> Enum.all?(fn el -> elem(el, 1) == :marked end)
      end
    end)
  end

  def whole_column_marked?(board) do
    Enum.zip_with(board, & &1)
    |> whole_row_marked?
  end
end

# Parse input

input = File.read!("inputs/04.txt") |> String.split("\n\n", trim: true)

numbers =
  input
  |> hd()
  |> String.split(",", trim: true)

boards =
  input
  |> tl()
  |> Stream.map(&String.split(&1, "\n"))
  |> Stream.map(fn board -> board |> Enum.map(&String.split(&1)) end)
  |> Enum.to_list()

# Play Bingo

{winning_board, number} =
  boards
  |> Bingo.initialize()
  |> Bingo.play(numbers)
  |> IO.inspect()

sum =
  winning_board
  |> Enum.reduce(0, fn row, sum ->
    s =
      row
      |> Enum.reduce(0, fn el, sum ->
        if elem(el, 1) == :unmarked do
          String.to_integer(elem(el, 0)) + sum
        else
          sum
        end
      end)

    s + sum
  end)

(sum * number) |> IO.inspect()
