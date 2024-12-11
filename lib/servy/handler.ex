defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."

  require Logger

  import Servy.FileHandler, only: [handle_file: 2]
  import Servy.Parser, only: [parse: 1]
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]

  alias Servy.BearController
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
    %{conv | resp_body: resp_body}
  end

  defp emojify(%Conv{} = conv), do: conv

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    Logger.info("What about 2nd breakfast?")
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    Logger.warning("uh oh. i messed up")
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    Logger.error("No can do")
    BearController.delete(conv, conv.params)
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

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: _method, path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: text/html\r
    Content-Length: #{byte_size(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end
