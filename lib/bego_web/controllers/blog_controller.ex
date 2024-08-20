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

  def rss(conn, _) do
    rss = Blog.rss()

    conn
    |> put_resp_content_type("application/xml")
    |> send_resp(200, rss)
  end
end
