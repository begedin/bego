defmodule BegoWeb.BlogHTML do
  use BegoWeb, :html

  @spec render(<<_::64, _::_*8>>, any()) :: Phoenix.LiveView.Rendered.t()
  def render("index.html", assigns) do
    ~H"""
    <p :if={assigns[:tag]} class="text-slate-900 text-italic">
      <span>Posts tagged with</span> <strong><%= @tag %></strong>
    </p>
    <div class="w-full flex flex-col gap-10">
      <article :for={post <- @posts} class="flex flex-col justify-start">
        <h1 class="font-bold text-4xl">
          <a class="text-blue-900 visited:text-blue-800" href={~p"/blog/#{post.id}"}>
            <%= post.title %>
          </a>
        </h1>
        <span class="text-sm text-gray-600 font-bold font-italic"><%= post.date %></span>
        <span class="text-gray-900 post"><%= Phoenix.HTML.raw(post.description) %></span>
      </article>
    </div>
    """
  end

  def render("show.html", assigns) do
    ~H"""
    <div class="flex flex-col gap-1">
      <h1 class="font-bold text-5xl pb-8  text-emerald-900"><%= @post.title %></h1>

      <div class="flex flex-row gap-1">
        <a
          :for={tag <- @post.tags}
          class="p-1 bg-slate-200 rounded-md gap-1 text-blue-900 visited:text-blue-800"
          href={~p"/blog/tags/#{tag}"}
        >
          <%= tag %>
        </a>
      </div>
      <article class="post">
        <%= Phoenix.HTML.raw(@post.body) %>
      </article>
    </div>
    """
  end

  def render("404.html", assigns) do
    ~H"""
    <h1 class="font-bold text-5xl pb-8  text-emerald-900">Post not found</h1>
    <p>Sorry, the post you are looking for does not exist. It may have been moved or deleted.</p>
    """
  end
end
