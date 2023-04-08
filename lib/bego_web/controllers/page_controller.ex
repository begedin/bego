defmodule BegoWeb.PageController do
  use BegoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def talks(conn, _params) do
    render(conn, "talks.html")
  end

  def work(conn, _params) do
    render(conn, "work.html")
  end

  def posts(conn, _params) do
    render(conn, "posts.html")
  end

  def post(conn, %{"post" => "vue3-list-render-performance"}) do
    render(conn, "vue3_list_render_performance.html")
  end
end
