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
end
