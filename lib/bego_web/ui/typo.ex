defmodule BegoWeb.UI.Typo do
  use Phoenix.Component

  def h1(assigns) do
    class = "text-2xl font-bold text-emerald-900"

    ~H"""
    <h1 class={class}>
      <%= render_slot(@inner_block) %>
    </h1>
    """
  end

  def h2(assigns) do
    class = "text-xl font-bold text-emerald-800"

    ~H"""
    <h2 class={class}><%= render_slot(@inner_block) %></h2>
    """
  end

  def p(assigns) do
    ~H"""
    <p><%= render_slot(@inner_block) %></p>
    """
  end
end
