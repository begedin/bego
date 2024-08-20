defmodule Bego.Blog do
  use NimblePublisher,
    build: Bego.Blog.Post,
    from: Application.app_dir(:bego, "priv/blog/**/*.md"),
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_ts]

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  def list_posts() do
    @posts
  end

  def list_posts_by_tag(tag) do
    Enum.filter(@posts, &(tag in &1.tags))
  end

  def find_by_id(slug) do
    Enum.find(@posts, &(&1.id == slug))
  end

  use BegoWeb, :verified_routes

  def rss() do
    posts = list_posts()
    items = posts |> Enum.map_join("", &link_xml/1)
    most_recent_date = posts |> Enum.at(0) |> Map.get(:date)

    """
    <?xml version="1.0" encoding="UTF-8" ?>
    <rss xmlns:atom="http://www.w3.org/2005/Atom" version="2.0">
      <channel>
        <title>bego.dev blog</title>
        <link>https://bego.dev/blog/</link>
        <description>Recent content by @begedinnikola</description>
        <language>en-us</language>
        <lastBuildDate>#{Calendar.strftime(most_recent_date, "%a, %d %B %Y 00:00:00 +0000")}</lastBuildDate>
        <copyright>© 2024 Nikola Begedn</copyright>
        #{items}
      </channel>
    </rss>
    """
  end

  defp link_xml(post) do
    link = url(~p"/blog/#{post.id}")

    """
    <item>
      <title>#{post.title}</title>
      <description>#{Floki.text(post.description)}</description>
      <pubDate>#{Calendar.strftime(post.date, "%a, %d %B %Y 00:00:00 +0000")}</pubDate>
      <link>#{link}</link>
      <guid isPermaLink="true">#{link}</guid>
    </item>
    """
  end
end
