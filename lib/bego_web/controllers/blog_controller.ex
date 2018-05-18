defmodule BegoWeb.PageController do
  use BegoWeb, :controller

  defp url(slug) do
    "https://api.buttercms.com/v2/posts/?page=1&page_size=10&auth_token=#{auth_token()}'"
  end

  defp auth_token() do
    Application.get_env(:bego, :buttercms_token)
  end

  def index(conn, %{"slug" => slug}) do
    with %{status_code: 200, body: body} <- slug |> url() |> HTTPoison.get(), {:ok, data} = Poison.decode(body) do
      conn
      |> assign(:data, data)
      |> render("show.html")
    end
  end
end
