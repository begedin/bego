defmodule BegoWeb.UI.Element do
  use Phoenix.Component

  def card(assigns) do
    spacing =
      case Map.get(assigns, :spacing, "medium") do
        "medium" -> "space-y-2"
        "large" -> "space-y-4"
      end

    ~H"""
    <section class={"#{spacing} bg-slate-50 p-5 shadow-slate-100 shadow-md"}>
      <%= render_slot(@inner_block) %>
    </section>
    """
  end

  def section(assigns) do
    ~H"""
    <section>
      <%= render_slot(@inner_block) %>
    </section>
    """
  end

  def youtube(%{url: _, title: _} = assigns) do
    ~H"""
    <iframe
      class="h-full w-full"
      src={"https://www.youtube.com/embed/#{@url}"}
      title={@title}
      frameborder="0"
      allow="accelerometer; gyroscope"
      allowfullscreen></iframe>
    """
  end

  def video(assigns) do
    ~H"""
    <div class="rounded-lg aspect-video">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
