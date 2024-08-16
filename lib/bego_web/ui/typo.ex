defmodule BegoWeb.UI.Typo do
  use Phoenix.Component

  def h1(assigns) do
    ~H"""
    <h1 class="text-2xl font-bold text-emerald-900">
      <%= render_slot(@inner_block) %>
    </h1>
    """
  end

  def h2(assigns) do
    ~H"""
    <h2 class="text-xl font-bold text-emerald-800"><%= render_slot(@inner_block) %></h2>
    """
  end

  def p(assigns) do
    ~H"""
    <p><%= render_slot(@inner_block) %></p>
    """
  end

  def a(%{href: _} = assigns) do
    ~H"""
    <a class="text-sky-600" href={@href}><%= render_slot(@inner_block) %></a>
    """
  end
end
