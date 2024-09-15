defmodule BegoWeb.Layouts do
  use BegoWeb, :html
  use Phoenix.Component

  alias BegoWeb.UI.Social
  alias BegoWeb.UI.Typo

  def render("root.html", assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="csrf-token" content={get_csrf_token()} />
        <.live_title>
          <%= assigns[:page_title] || "" %>
        </.live_title>
        <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"} />
        <link
          rel="alternate"
          type="application/atom+xml"
          title="RSS Feed for bego.dev/blog"
          href={~p"/blog/feed.xml"}
        />
        <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}>
        </script>
        <!-- SEO -->
        <%= if assigns[:post] do %>
          <link rel="canonical" href={url(~p"/blog/#{@post.id}")} />
          <meta name="description" content={@post.description |> Floki.text() |> String.trim()} />
          <meta property="og:title" content={@post.title} />
          <meta property="og:url" content={url(~p"/blog/#{@post.id}")} />
          <meta property="og:description" content={@post.description |> Floki.text() |> String.trim()} />
        <% else %>
          <link rel="canonical" href={String.replace(@conn.host, ".fly", "")  <> @conn.request_path} />
        <% end %>
      </head>
      <body>
        <.header_section {assigns} />
        <%= @inner_content %>
        <.footer {assigns} />
      </body>
    </html>
    """
  end

  def render("live.html", assigns) do
    ~H"""
    <.main {assigns}>
      <%= @inner_content %>
    </.main>
    """
  end

  def render("app.html", assigns) do
    ~H"""
    <.main {assigns}>
      <.flash_group flash={@flash} />
      <%= @inner_content %>
    </.main>
    """
  end

  def render("blog.html", assigns) do
    ~H"""
    <style type="text/css">
      <%= Makeup.stylesheet(:default_style, "makeup") %>
    </style>
    <main class="my-1line blog-post">
      <%= @inner_content %>
    </main>
    """
  end

  defp main(assigns) do
    ~H"""
    <main class="my-1line">
      <%= render_slot(@inner_block) %>
    </main>
    """
  end

  defp header_section(assigns) do
    ~H"""
    <header class="py-2lines">
      <section class="flex flex-col md:flex-row items-start md:justify-between gap-x-1 gap-y-1line">
        <h1 class="text-lg sm:min-w-max"><a href="/">Bego Solutions</a></h1>
        <.navigation {assigns} />
      </section>
    </header>
    """
  end

  defp navigation(assigns) do
    ~H"""
    <nav>
      <ul class="flex flex-col items-start md:flex-row flex-wrap justify-center md:justify-end gap-x-1">
        <li><a class="hover:underline" href="https://livepixel.bego.dev">Games</a></li>
        <li>
          <a class="hover:underline" href="https://permaplanner.bego.dev">Permaplanner</a>
        </li>
      </ul>
      <ul class="flex flex-col items-start md:flex-row flex-wrap justify-center md:justify-end gap-x-1">
        <li><a class="hover:underline" href="/oss">OSS</a></li>
        <li>
          <a class="hover:underline" href="/blog">Blog</a><a
            class="hover:underline"
            href="/blog/feed.xml"
          >(RSS)</a>
        </li>
        <li><a class="hover:underline" href="/talks">Talks</a></li>
        <li><a class="hover:underline" href="/work">Work</a></li>
      </ul>
    </nav>
    """
  end

  defp footer(assigns) do
    ~H"""
    <footer class="pt-3lines pb-1line flex flex-col gap-y-1line items-start md:flex-row md:items-center md:justify-between">
      <div class="flex flex-col items-start">
        <div class="text-md text-slate-500">
          This is
          <Typo.a href="https://github.com/begedin/bego">open source</Typo.a>.
        </div>

        <div class="text-md text-slate-500">
          Copyright Bego Rješenja <%= Date.utc_today() |> Map.get(:year) %>.
        </div>
        <address class="text-md text-slate-500 not-italic">
          Ulica Zrinskih i Frankopana 4,<br /> 42000 Varaždin, Croatia.
        </address>
      </div>

      <div class="grid grid-cols-4 md:grid-cols-2  gap-x-2 gap-y-1line">
        <Social.github />
        <Social.twitter />
        <Social.linkedin />
        <Social.email />
      </div>
    </footer>
    """
  end
end
