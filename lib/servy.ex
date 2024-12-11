defmodule Servy do
  def hello do
    :world
  end

  def hello(name) do
    "Howdy, #{name}"
  end
end

# IO.puts(Servy.hello("Elixir"))
