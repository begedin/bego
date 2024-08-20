defmodule BegoWeb.UI.Element do
  use Phoenix.Component

  def card(assigns) do
    spacing =
      case Map.get(assigns, :spacing, "medium") do
        "medium" -> "space-y-1.2"
        "large" -> "space-y-2.4"
      end

    assigns = assign(assigns, :spacing, spacing)

    ~H"""
    <section class={"#{@spacing} py-1.2"}>
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
      class="h-[22.8rem] w-full"
      src={"https://www.youtube.com/embed/#{@url}"}
      title={@title}
      frameborder="0"
      allow="accelerometer; gyroscope"
      allowfullscreen
    >
    </iframe>
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
