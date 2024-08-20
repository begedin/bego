defmodule BegoWeb.Layouts do
  use BegoWeb, :html
  use Phoenix.Component

  alias BegoWeb.UI.Social
  alias BegoWeb.UI.Typo

  def render("root.html", assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" class="h-full">
      <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
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
      </head>
      <body class="flex flex-col h-screen">
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
    <main class="mx-auto max-w-prose my-1.2 flex-grow blog-post">
      <%= @inner_content %>
    </main>
    """
  end

  defp main(assigns) do
    ~H"""
    <main class="mx-auto max-w-prose my-1.2 flex-grow">
      <%= render_slot(@inner_block) %>
    </main>
    """
  end

  defp header_section(assigns) do
    ~H"""
    <header class="px-2 py-2.4">
      <section class="mx-auto max-w-prose flex flex-row items-center justify-between gap-1">
        <h1 class="text-lg min-w-max"><a href="/">Bego Solutions</a></h1>
        <.navigation {assigns} />
      </section>
    </header>
    """
  end

  defp navigation(assigns) do
    ~H"""
    <nav>
      <ul class="flex flex-row flex-wrap justify-end gap-x-1">
        <li><a class="hover:underline" href="https://livepixel.bego.dev">Games</a></li>
        <li>
          <a class="hover:underline" href="https://permaplanner.bego.dev">Permaplanner</a>
        </li>
      </ul>
      <ul class="flex flex-row flex-wrap justify-end gap-x-1">
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
    <footer class="h-5 px-2 py-2.4">
      <section class="px-1 py-1.2 flex flex-row items-center justify-between">
        <.copyright />
        <div class="grid grid-flow-col gap-x-2 gap-y-2.4">
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
    <div class="flex flex-col items-start">
      <div class="text-md text-slate-500">
        Copyright Bego Rješenja <%= Date.utc_today() |> Map.get(:year) %>.
      </div>
      <div class="text-md text-slate-500">
        Ulica Zrinskih i Frankopana 4, 42000 Varaždin, Croatia.
      </div>
      <div class="text-md text-slate-500">
        Contact via
        <Typo.a href="mailto:begedinnikola+bego.dev@gmail.com">email</Typo.a>
      </div>
    </div>
    """
  end
end
