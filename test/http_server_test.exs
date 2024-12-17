defmodule HttpSeverTest do
  use ExUnit.Case, async: true

  alias Servy.HttpServer

  test "accepts a request on a socket and sends back a response" do
    spawn(fn -> HttpServer.start(4000) end)
    {:ok, response} = HTTPoison.get("http://localhost:4000/wildthings")
    assert response.status_code == 200
    assert response.body == "Bears, Lions, Tigers"
  end
end
