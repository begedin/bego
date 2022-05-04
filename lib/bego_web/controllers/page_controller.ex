defmodule BegoWeb.PageController do
  use BegoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
