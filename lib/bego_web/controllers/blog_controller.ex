defmodule BegoWeb.BlogController do
  use BegoWeb, :controller

  defp index_url() do
    "https://api.buttercms.com/v2/posts/?page=1&page_size=10&auth_token=#{auth_token()}"
  end

  defp post_url(slug) do
    "https://api.buttercms.com/v2/posts/#{slug}/?auth_token=#{auth_token()}"
  end

  defp auth_token() do
    Application.get_env(:bego, :buttercms_token)
  end

  def index(conn, %{}) do
    IO.puts("index")

    with {:ok, %{status_code: 200, body: body}} <- index_url() |> HTTPoison.get(),
         {:ok, data} <- Poison.decode(body),
         %{"data" => posts} <- data do
      conn
      |> assign(:posts, posts)
      |> render("index.html")
    end
  end

  def show(conn, %{"slug" => slug}) do
    with {:ok, %{status_code: 200, body: body}} <- slug |> post_url() |> HTTPoison.get(),
         {:ok, data} <- Poison.decode(body),
         %{"data" => post} <- data do
      conn
      |> assign(:post, post)
      |> render("show.html")
    end
  end
end
