defmodule BegoWeb.BlogController do
  use BegoWeb, :controller

  alias Bego.Blog

  plug :put_layout, html: {BegoWeb.Layouts, :blog}

  def index(conn, _) do
    posts = Blog.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def by_tag(conn, %{"tag" => tag}) do
    posts = Blog.list_posts_by_tag(tag)
    render(conn, "index.html", posts: posts, tag: tag)
  end

  def show(conn, %{"id" => id}) do
    case Blog.find_by_id(id) do
      nil -> conn |> put_status(404) |> render("404.html")
      post -> render(conn, "show.html", post: post)
    end
  end
end
