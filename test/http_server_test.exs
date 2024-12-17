defmodule HttpSeverTest do
  use ExUnit.Case, async: true

  alias Servy.HttpServer

  test "accepts a request on a socket and sends back a response" do
    spawn(fn -> HttpServer.start(4000) end)
    parent = self()
    max_concurrent_requests = 5

    for _ <- 1..max_concurrent_requests do
      spawn(fn ->
        {:ok, response} = HTTPoison.get("http://localhost:4000/wildthings")
        send(parent, {:response, response})
      end)
    end

    for _ <- 1..max_concurrent_requests do
      receive do
        {:response, response} ->
          assert response.status_code == 200
          assert response.body == "Bears, Lions, Tigers"
      end
    end
  end
end
