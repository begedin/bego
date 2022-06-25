defmodule BegoWeb.PageView do
  use BegoWeb, :view

  use Phoenix.Component

  alias BegoWeb.Page.Talks
  alias BegoWeb.Page.Work
  alias BegoWeb.UI.Typo

  def render("index.html", assigns) do
    ~H"""
    <div class="space-y-5">
      <Typo.h1>
        I work with small/medium teams or alone, to deliver any software needed
      </Typo.h1>
      <Typo.p>
        For the product, the goal is quality and maintainability. I will deliver
        the product, but anyone will be able to maintain it.</Typo.p>
      <Typo.p>
        For the customer, the goal is communication and openness. Things don't
        always go to plan, but you will know how and why, and you will be given
        options and information you need.</Typo.p>
      </div>
    """
  end

  def render("talks.html", assigns) do
    Talks.talks(assigns)
  end

  def render("work.html", assigns) do
    Work.work(assigns)
  end
end
