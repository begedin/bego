defmodule BegoWeb.LayoutView do
  use BegoWeb, :view
  use Phoenix.Component

  alias BegoWeb.UI.Social
  alias BegoWeb.UI.Typo

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def render("root.html", assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" class="h-full">
      <head>
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <%= csrf_meta_tag() %>
        <%= assigns |> Map.get(:page_title, "Bego") |> live_title_tag() %>
        <link
          phx-track-static
          rel="stylesheet"
          href={Routes.static_path(@conn, "/assets/app.css")}/>
        <script
          defer
          phx-track-static
          type="text/javascript"
          src={Routes.static_path(@conn, "/assets/app.js")}></script>
      </head>
      <body class="flex flex-col h-screen justify-between">
        <.header {assigns} />
        <%= @inner_content %>
        <.footer {assigns} />
      </body>
    </html>
    """
  end

  def render("live.html", assigns) do
    ~H"""
    <.main {assigns}>
      <Typo.p class="alert alert-info" role="alert"
        phx-click="lv:clear-flash"
        phx-value-key="info"><%= live_flash(@flash, :info) %></Typo.p>

      <Typo.p class="alert alert-danger" role="alert"
        phx-click="lv:clear-flash"
        phx-value-key="error"><%= live_flash(@flash, :error) %></Typo.p>

      <%= @inner_content %>
    </.main>
    """
  end

  def render("app.html", assigns) do
    ~H"""
    <.main {assigns}>
      <Typo.p class="alert alert-info" role="alert"><%= get_flash(@conn, :info) %></Typo.p>
      <Typo.p class="alert alert-danger" role="alert"><%= get_flash(@conn, :error) %></Typo.p>
      <%= @inner_content %>
    </.main>
    """
  end

  defp main(assigns) do
    ~H"""
    <main class="mx-auto max-w-prose mt-5 mb-5 flex-grow">
      <%= render_slot(@inner_block) %>
    </main>
    """
  end

  defp header(assigns) do
    ~H"""
    <header class="bg-slate-100 p-10">
      <section class="mx-auto grid grid-flow-col auto-cols-auto space-x-10 items-center">
        <h1 class="text-5xl">Bego Solutions</h1>
        <.navigation {assigns}/>
      </section>
    </header>
    """
  end

  defp navigation(assigns) do
    ~H"""
    <nav>
      <ul class="grid grid-flow-col auto-cols-min space-x-5">
        <li><a href="/">Home</a></li>
        <li><a href="/talks">Talks</a></li>
        <li><a href="/work">Work</a></li>
        <%= if function_exported?(Routes, :live_dashboard_path, 2) do %>
          <li>
            <% path = Routes.live_dashboard_path(@conn, :home) %>
            <%= link("LiveDashboard", to: path) %>
          </li>
        <% end %>
      </ul>
    </nav>
    """
  end

  defp footer(assigns) do
    ~H"""
    <footer class="mt-auto bg-slate-100">
      <section class="container mx-auto py-10 flex flex-row space-x-10 justify-between">
        <.copyright />
        <div class="grid grid-flow-col space-x-3">
          <Social.github />
          <Social.twitter />
          <Social.linkedin />
        </div>
      </section>
    </footer>
    """
  end

  defp copyright(assigns) do
    ~H"""
    Copyright Bego Rješenja <%= Date.utc_today() |> Map.get(:year) %>
    """
  end
end
