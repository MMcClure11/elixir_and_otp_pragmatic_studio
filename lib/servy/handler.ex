defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."

  require Logger

  import Servy.FileHandler, only: [handle_file: 2]
  import Servy.Parser, only: [parse: 1]
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]

  alias Servy.Conv

  #  File.cwd! returns the current working directory.
  #  mix always runs from the root project directory which is the top-level
  #  servy directory in our case. So calling File.cwd! always returns the
  #  top-level servy directory. And relative to that directory, the pages
  #  directory is just one level down.
  @pages_path Path.expand("pages", File.cwd!())

  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> emojify
    |> format_response
  end

  defp emojify(%Conv{status: 200, resp_body: resp_body} = conv) do
    emojies = String.duplicate("🎉", 5)
    body = emojies <> "\n" <> resp_body <> "\n" <> emojies

    %{conv | resp_body: body}
  end

  defp emojify(%Conv{} = conv), do: conv

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    Logger.info("What about 2nd breakfast?")
    %{conv | status: 200, resp_body: "Bears, Liöns, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    Logger.warning("uh oh. i messed up")
    %{conv | status: 200, resp_body: "Winnie, Paddington, Smokey"}
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Bears id #{id}"}
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    Logger.error("No can do")
    %{conv | status: 200, resp_body: "Deleting bears is not allowed!"}
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  # Suppose you had other static pages in the pages directory such as
  # contact.html, faq.html, and so on. You already know how to define separate
  # route functions that serve each of those files. Instead, how would you
  # define one generic route function that handles the following requests:

  def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
    @pages_path
    |> Path.join(file <> ".html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: _method, path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
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

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bears?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)
