defmodule BegoWeb.PageControllerTest do
  use BegoWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Bego Solutions"
  end
end
