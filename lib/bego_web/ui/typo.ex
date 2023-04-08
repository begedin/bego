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

  def a(%{href: _} = assigns) do
    ~H"""
    <a class="text-sky-600" href={@href}><%= render_slot(@inner_block) %></a>
    """
  end

  slot(:inner_block, required: true)

  def code(assigns) do
    ~H"""
    <span class="font-mono text-red-500"><%= render_slot(@inner_block) %></span>
    """
  end
end
