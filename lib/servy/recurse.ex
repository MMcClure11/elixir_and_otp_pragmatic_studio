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

  def triple([head | tail], triple) do
    triple(tail, triple ++ [head * 3])
  end

  def triple([], triple), do: dbg(triple)
end

Recurse.loopy([1, 2, 3, 4, 5])
Recurse.sum([1, 2, 3, 4, 5], 0)
Recurse.triple([1, 2, 3, 4, 5], [])
