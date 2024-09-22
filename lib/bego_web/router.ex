defmodule BegoWeb.Router do
  use BegoWeb, :router

  defp redirect_from_fly(conn, _opts) do
    if String.contains?(conn.host, ".fly.dev") do
      conn
      |> Plug.Conn.put_status(301)
      |> Phoenix.Controller.redirect(external: "https://bego.dev" <> conn.request_path)
      |> halt()
    else
      conn
    end
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :redirect_from_fly
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BegoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BegoWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/talks", PageController, :talks
    get "/work", PageController, :work
    get "/oss", PageController, :open_source
    get "/blog", BlogController, :index
    get "/blog/tags/:tag", BlogController, :by_tag
    get "/blog/feed.xml", BlogController, :rss
    get "/blog/:id", BlogController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", BegoWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  import Phoenix.LiveDashboard.Router

  if Mix.env() in [:dev, :test] do
    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BegoWeb.Telemetry
    end
  end
end
