defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def log(conv), do: IO.inspect(conv)

  def parse(request) do
    [method, path, _version] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: ""}
  end

  def route(conv) do
    %{conv | resp_body: "Bears, Liöns, Tigers"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

# Request line, method, path upon which to perform the reuest, the http protocol
# GET /wildthings HTTP/1.1
# List of headers (key/value pairs)
# Host: example.com
# User-Agent: ExampleBrowser/1.0 <- who is making the request
# Accept: */* <- media types acceptable (any in this case)
# Last line is blank because after the blank line comes the body of the
# response (we don’t have one atm)

# Status line, HTTP version, status code, reason phrase
# HTTP/1.1 200 OK
# Response Headers (key/value pairs)
# Content-Type: text/html
# Content-Length: 20
#
# Bears, Lions, Tigers <- body of the response
#
request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)
