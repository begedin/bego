defmodule BegoWeb.Router do
  use BegoWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", BegoWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", BlogController, :index)
    get("/:slug", BlogController, :show)
  end
end
