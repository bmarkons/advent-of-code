defmodule Solution do
  def run(commands) do
    commands
    |> Enum.reduce({0, 0, 0}, fn command, {x, y, aim} -> run_single(command, x, y, aim) end)
  end

  def run_single({command, steps}, x, y, aim) do
    steps = steps |> String.to_integer()

    case command do
      "forward" ->
        {x + steps, y + steps * aim, aim}

      "down" ->
        {x, y, aim + steps}

      "up" ->
        {x, y, aim - steps}

      _ ->
        {x, y, aim}
    end
  end
end

File.read!("inputs/02.txt")
|> String.split()
|> Enum.chunk_every(2)
|> Enum.map(&List.to_tuple/1)
|> Solution.run()
|> IO.inspect()
