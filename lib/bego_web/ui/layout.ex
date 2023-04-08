defmodule BegoWeb.UI.Layout do
  use Phoenix.Component

  def column_1(assigns) do
    ~H"""
    <div class="space-y-5">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end