defmodule Servy.Timer do
  def remind(reminder, seconds) do
    spawn(fn ->
      :timer.sleep(seconds * 1000)
      IO.puts(reminder)
    end)
  end
end
