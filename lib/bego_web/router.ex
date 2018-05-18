defmodule BegoWeb.Router do
  use BegoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BegoWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/blog/:slug", BlogController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", BegoWeb do
  #   pipe_through :api
  # end
end
