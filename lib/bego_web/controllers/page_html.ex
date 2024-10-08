defmodule BegoWeb.PageHTML do
  use BegoWeb, :html

  use Phoenix.Component

  alias BegoWeb.Page.Index
  alias BegoWeb.Page.OpenSource
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

  def render("open_source.html", assigns) do
    OpenSource.open_source(assigns)
  end
end
