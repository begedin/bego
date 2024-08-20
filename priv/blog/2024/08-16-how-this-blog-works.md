%{
  title: "How this blog is setup",
  author: "@begedinnikola",
  tags: ~w(elixir nimble_publisher earmark),
  description: "An overview how how this blog integrates into the **Phoenix** application that is this website."
}
---
# The basic overview

This website, not including the external links to my [games showcase](https://livepixel.bego.dev) and my [Permaplanner side project](https://permaplanner.bego.dev) is a simple phoenix application, using plain static HTML, tailwind and esbuild.

[NimblePublisher](https://github.com/dashbitco/nimble_publisher) is an extremely lighweight elixir library that allows you to write blog posts as markdown files. This is great because, while they are files in your repository, they do not actually require disk storage when deployed to prod. Rather, the way the html is generated from markdown makes the articles part of compilation process and thus part of the code that's running your app.

Integration of it is quite simple and there's plenty of info in [hexdocs](https://hexdocs.pm/nimble_publisher/NimblePublisher.html) on various things you can do.

For my purpose, I needed to solve a few extra things

- getting it integrated into the app layout
- getting it to behave with tailwind
- getting markdown support into post description

## Integration into app layout

The basic integration was as straightforward as the docs said.

I created a `Bego.Blog.Post` exactly as instructed in the docs

```elixir
defmodule Bego.Blog.Post do
  @enforce_keys [
    :id, :author, :title, 
    :body, :description, :tags, :date
  ]
  defstruct [
    :id, :author, :title, 
    :body, :description, :tags, :date
  ]

  def build(filename, attrs, body) do
    [year, month_day_id] = 
      filename 
      |> Path.rootname() 
      |> Path.split() 
      |> Enum.take(-2)
    [month, day, id] = String.split(month_day_id, "-", parts: 3)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")
    struct!(
      __MODULE__, 
      [id: id, date: date, body: body] ++ Map.to_list(attrs)
    )
  end
end
```

I created a `Bego.Blog` as a context to fetch a list of posts and an individual post

```elixir
defmodule Bego.Blog do
  use NimblePublisher,
    build: Bego.Blog.Post,
    from: Application.app_dir(:bego, "priv/blog/**/*.md"),
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang]

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  def list_posts() do
    @posts
  end

  def find_by_id(slug) do
    Enum.find(@posts, &(&1.id == slug))
  end
end
```

Then, I added a route and a controller:


```elixir
# router.ex

get "/blog", BlogController, :index
get "/blog/:id", BlogController, :show

# controller 

defmodule BegoWeb.BlogController do
  use BegoWeb, :controller

  alias Bego.Blog

  def index(conn, _) do
    posts = Blog.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Blog.find_by_id(id)
    render(conn, "show.html", post: post)
  end
end
```

This allowed me to write `.md` files inside `priv/{year}/{month}-{day}-{id}.md` that automatically become renderable blog posts using an html module.

```elixir
defmodule BegoWeb.BlogHTML do
  use BegoWeb, :html

  def render("index.html", assigns) do
    ~H"""
    <ul class="w-full">
      <li :for={post <- @posts} class="flex flex-col justify-start">
        <article class="flex flex-col">
          <h1 class="font-bold text-lg">
            <a class="text-blue-900 visited:text-blue-800" href={~p"/blog/#{post.id}"}>
              <%= post.title %>
            </a>
          </h1>
          <span class="text-sm text-gray-700 font-bold"><%= post.date %></span>
          <span class="text-gray-900"><%= post.description %></span>
        </article>
      </li>
    </ul>
    """
  end

  def render("show.html", assigns) do
    ~H"""
    <h1 class="font-bold text-lg pb-8"><%= @post.title %></h1>
    <article class="post">
      <%= Phoenix.HTML.raw(@post.body) %>
    </article>
    """
  end
end
```

## Getting it to behave with tailwind

Using tailwind for the structure is easy enough, as you can tell in the example above.

However, for the post body, I'm using `Phoenix.HTML.Raw` to get the generated post body rendered. This is great for the content, but I can't exactly add tailwind classes to it.

What I can do, is use tailwind's `@apply` statement to get plain html treated as if it has tailwind classes.

```css
/* app.css */


.post h1 {
  @apply py-2 font-sans text-lg font-bold;
}

.post h2 {
  @apply py-2 font-sans text-lg font-bold;
}

.post h3 {
  @apply py-2 font-sans text-lg font-bold;
}

.post p {
  @apply py-4;
}

.post a {
  @apply text-blue-500;
}

/* etc. */
```

This is just the basic initial stuff, but of course, you can extend this as far as you want.

It's not the nicest. I didn't quite figure out how to separate the main css out with import statements, but I can figure that out later. It works for now.


## Markdown support in the post description

This one was extremely straightforward. I just slightly tweaked `post.ex`

```elixir
defmodule Bego.Blog.Post do
  # ...

  def build(filename, attrs, body) do
    [year, month_day_id] = 
      filename 
      |> Path.rootname() 
      |> Path.split() 
      |> Enum.take(-2)
    [month, day, id] = String.split(month_day_id, "-", parts: 3)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")
    attrs = Map.put(
      attrs, 
      :description, 
      Earmark.as_html!(attrs.description)
    )
    struct!(
      __MODULE__, 
      [id: id, date: date, body: body] ++ Map.to_list(attrs)
    )
  end
end
```

That's all there is to it. Any markdown in the description field is now parsed into html.

```markdown
%{
  title: "How this blog is setup",
  author: "@begedinnikola",
  tags: ~w(hello),
  description: "An overview how how this blog integrates into the **Phoenix** application that is this website."
}
---
# The basic overview

This website, not including the external

...etc.
```

# What's left?

I didn't quite get synthax higlighting. I have it built in for elixir, since `NimblePublisher` relis internally on `Earmark` and then uses `Makeup` for code highlighting. 

The thing is `Makeup` doesn't support a lot of languages and I'm not solely an elixir engineer, so I will need more at some point soon.

It works for now, though.



