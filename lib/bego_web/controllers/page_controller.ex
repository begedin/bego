defmodule BegoWeb.PageController do
  use BegoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", page_title: "Bego.dev")
  end

  def talks(conn, _params) do
    render(conn, "talks.html", page_title: "Talks | Bego.dev")
  end

  def work(conn, _params) do
    render(conn, "work.html", page_title: "Work | Bego.dev")
  end

  def open_source(conn, _params) do
    render(conn, "open_source.html", page_title: "Open Source Work | Bego.dev")
  end
end
