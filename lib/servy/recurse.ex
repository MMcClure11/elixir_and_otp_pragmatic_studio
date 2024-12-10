defmodule Recurse do
  def loopy([head | tail]) do
    IO.puts("Head: #{head} Tail: #{inspect(tail)}")
    loopy(tail)
  end

  def loopy([]), do: IO.puts("Done!")

  def sum([head | tail], total) do
    sum(tail, Enum.sum([head, total]))
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

  def my_map(current_list, multiply) do
    my_map(current_list, multiply, [])
  end

  defp my_map([head | tail], multiply, current_list) do
    my_map(tail, multiply, [multiply.(head) | current_list])
  end

  defp my_map([], _multiply, current_list), do: current_list |> Enum.reverse()
end

Recurse.loopy([1, 2, 3, 4, 5])
Recurse.sum([1, 2, 3, 4, 5], 0)
IO.inspect(Recurse.triple([1, 2, 3, 4, 5]))
IO.puts("my_map: ")
IO.inspect(Recurse.my_map([1, 2, 3, 4, 5], &(&1 * 4)))
