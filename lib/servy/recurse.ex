defmodule Recurse do
  def loopy([head | tail]) do
    IO.puts("Head: #{head} Tail: #{inspect(tail)}")
    loopy(tail)
  end

  def loopy([]), do: IO.puts("Done!")

  def sum([head | tail], total) do
    sum(tail, head + total)
  end

  def sum([], total), do: IO.puts("Total: #{total}")

  def triple([head | tail]) do
    [head * 3 | triple(tail)]
  end

  def triple([]), do: []
end

Recurse.loopy([1, 2, 3, 4, 5])
Recurse.sum([1, 2, 3, 4, 5], 0)
IO.inspect(Recurse.triple([1, 2, 3, 4, 5]))
