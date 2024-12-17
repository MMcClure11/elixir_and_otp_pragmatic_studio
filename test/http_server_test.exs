defmodule HttpSeverTest do
  use ExUnit.Case, async: true

  alias Servy.HttpServer

  test "where_is_bigfoot" do
    spawn(HttpServer, :start, [4000])
    url = "http://localhost:4000/sensors"

    task = Task.async(fn -> HTTPoison.get(url) end)
    {:ok, response} = Task.await(task)
    assert response.status_code == 200

    assert remove_whitespace(response.body) ==
             remove_whitespace("""
             <h1>Sensors</h1>
             <h2>Snapshots</h2>
             <ul>
             <li><img src=\"cam-1-snapshot.jpg\" alt=\"snapshot\"></li>
             <li><img src=\"cam-2-snapshot.jpg\" alt=\"snapshot\"></li>
             <li><img src=\"cam-3-snapshot.jpg\" alt=\"snapshot\"></li>
             </ul>
             <h2>Where Is Bigfoot?</h2>
             %{lat: \"29.0469 N\", lng: \"98.8667 W\"}
             """)
  end

  test "accepts a request on a socket and sends back a response" do
    spawn(HttpServer, :start, [4000])
    url = "http://localhost:4000/wildthings"

    1..5
    |> Enum.map(fn _ -> Task.async(fn -> HTTPoison.get(url) end) end)
    |> Enum.map(&Task.await/1)
    |> Enum.map(&assert_successful_response/1)
  end

  defp assert_successful_response({:ok, response}) do
    assert response.status_code == 200
    assert response.body == "Bears, Lions, Tigers"
  end

  test "accepts requests to many different urls" do
    spawn(HttpServer, :start, [4000])

    urls =
      [
        "http://localhost:4000/wildthings",
        "http://localhost:4000/bears",
        "http://localhost:4000/api/bears",
        "http://localhost:4000/bears/1",
        "http://localhost:4000/about"
      ]

    urls
    |> Enum.map(&Task.async(fn -> HTTPoison.get(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.map(&assert_200_response/1)
  end

  defp assert_200_response({:ok, response}) do
    assert response.status_code == 200
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
