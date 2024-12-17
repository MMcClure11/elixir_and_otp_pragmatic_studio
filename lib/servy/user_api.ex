defmodule Servy.UserApi do
  def query(id) do
    api_url(id)
    |> HTTPoison.get()
    |> handle_response
  end

  defp api_url(id) do
    "https://jsonplaceholder.typicode.com/users/#{id}"
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    city =
      body
      |> Poison.Parser.parse!(%{})
      |> get_in(["address", "city"])

    {:ok, city}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: _status, body: body}}) do
    message =
      body
      |> Poison.Parser.parse!(%{})
      |> get_in(["message"])

    {:error, message}
  end

  defp handle_response({:error, %{reason: reason}}), do: {:error, reason}
end
