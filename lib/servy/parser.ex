defmodule Servy.Parser do
  alias Servy.Conv, as: Conv
  # alias Servy.Conv this is shorthand for the above

  def parse(request) do
    [method, path, _version] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %Conv{method: method, path: path}
  end
end
