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

  def triple(list) do
    triple(list, [])
  end

  defp triple([head | tail], current_list) do
    triple(tail, [head * 3 | current_list])
  end

  defp triple([], current_list) do
    current_list |> Enum.reverse()
  end
end

Recurse.loopy([1, 2, 3, 4, 5])
Recurse.sum([1, 2, 3, 4, 5], 0)
IO.inspect(Recurse.triple([1, 2, 3, 4, 5]))
