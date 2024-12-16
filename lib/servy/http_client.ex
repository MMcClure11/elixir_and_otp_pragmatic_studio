defmodule Servy.HttpClient do
  @moduledoc """
  Exercise: practice converting erlang to elixir
  client() ->
    SomeHostInNet = "localhost", % to make it runnable on one machine
    {ok, Sock} = gen_tcp:connect(SomeHostInNet, 5678,
                                 [binary, {packet, 0}]),
    ok = gen_tcp:send(Sock, "Some Data"),
    ok = gen_tcp:close(Sock).

  ## Example

  iex -S mix
  iex(1)> request = \"""
  ...(1)> GET /bears HTTP/1.1\r
  ...(1)> Host: example.com\r
  ...(1)> User-Agent: ExampleBrowser/1.0\r
  ...(1)> Accept: */*\r
  ...(1)> \r
  ...(1)> \"""
  "GET /bears HTTP/1.1\r\nHost: example.com\r\nUser-Agent: ExampleBrowser/1.0\r\nAccept: */*\r\n\r\n"
  iex(2)> spawn(fn -> Servy.HttpServer.start(4000) end)
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 20\r
           \r
           Bears, Lions, Tigers
           """
  iex(3)> response = Servy.HttpClient.send_request(request)
  iex(4)> IO.puts response
  """
  def send_request(request) do
    some_host_in_net = ~c"localhost"

    {:ok, socket} =
      :gen_tcp.connect(some_host_in_net, 4000, [:binary, packet: :raw, active: false])

    :ok = :gen_tcp.send(socket, request)
    {:ok, response} = :gen_tcp.recv(socket, 0)
    :ok = :gen_tcp.close(socket)
    response
  end
end
