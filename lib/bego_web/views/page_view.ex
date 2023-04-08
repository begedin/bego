defmodule BegoWeb.PageView do
  use BegoWeb, :view

  use Phoenix.Component

  alias BegoWeb.Page.Index
  alias BegoWeb.Page.Posts
  alias BegoWeb.Page.Talks
  alias BegoWeb.Page.Work

  def render("index.html", assigns) do
    Index.index(assigns)
  end

  def render("talks.html", assigns) do
    Talks.talks(assigns)
  end

  def render("work.html", assigns) do
    Work.work(assigns)
  end

  def render("vue3_list_render_performance.html", assigns) do
    Posts.vue_3_list_render_performance(assigns)
  end
end
