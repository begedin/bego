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
end
