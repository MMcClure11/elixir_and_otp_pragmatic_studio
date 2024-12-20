defmodule Servy.Api.BearController do
  def index(conv) do
    json = Servy.Wildthings.list_bears() |> Poison.encode!()

    conv = put_resp_content_type(conv, "application/json")
    %{conv | status: 200, resp_body: json}
  end

  defp put_resp_content_type(conv, content_type) do
    headers = Map.put(conv.resp_headers, "Content-Type", content_type)

    %{conv | resp_headers: headers}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end
end
