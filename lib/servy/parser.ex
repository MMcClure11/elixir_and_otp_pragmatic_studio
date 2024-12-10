defmodule Servy.Parser do
  alias Servy.Conv, as: Conv
  # alias Servy.Conv this is shorthand for the above

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n", parts: 2)

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _version] = String.split(request_line, " ")

    headers = parse_headers(header_lines)

    params = parse_params(headers["Content-Type"], params_string)

    %Conv{method: method, path: path, params: params, headers: headers}
  end

  defp parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn x, acc ->
      [key, value] = String.split(x, ": ")
      Map.put(acc, key, value)
    end)
  end

  defp parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end

  defp parse_params(_content_type, _params_string), do: %{}
end
