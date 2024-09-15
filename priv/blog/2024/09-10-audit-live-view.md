%{
    title: "Setting up auditing for a phoenix_live_view application",
    tags: ~w(elixir phoenix phoenix_live_view macros),
    description: "Overview of first steps towards a CSS lexer for makeup",
    author: "@begedinnikola",
}
---

# Introduction

As I'm sure it is with many other Elixir companies, the product I work on uses [PhoenixLiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html) to build an admin dashboard. 

For a security compliance reason, I got asked to figure out if it's possible to somehow record every action the admin user performs in such an application, for auditing purposes.

Turns out, it's very possible, and as it is with many things Elixir, in relatively few lines of code.

# What is an action?

Thinking about how a live view works, it has lifecycle hooks

- `mount` - called when the page is opened up and then once more when the socket connects
- `handle_params` - called when params are received or changed from the url
- `handle_event` - called when an even is triggered, usually a user interaction
- `handle_info` - called when a message is sent to the live view process, maybe a pub-sub message, or an old-school async result
- `handle_async` - called when a more modern async result is received

Anything that happens in the live view, happens through one of these lifecycle hooks, so it would make sense to somehow boost them to do more.

# How do these hooks work?

These functions, you define in your live view and you actually only need to define those that are valid for your page. If there are no events, you don't need a `handle_event`, etc.

This is done via macros in the `Phoenix.LiveView` module. You're supposed to `use Phoenix.LiveView` which then calls the `__using__` macro, which sets everything up for you.

Usually, this is done indirectly by calling `use MyAppWeb, :live_view`.

# Could we do the same?

We sure could. There are several tools in the shed we can use.

- __using__ macro as an entry point to set everything up
- `@behavior` to ensure your live views define the necessary callbacks
- `@before_compile` as a way to predefine some functions in your live view process module
- `defoverridable` to grant the ability to override these functions
- the `Module` module, specifically `Module.defines?` to see which functions actually need to be setup

# How do we do it?

Let's give an example of a simplified `LiveAudit` module. We plug it into our app like this:

```elixir
# my_app_web.ex
def live_view do
  quote do
    use Phoenix.LiveView, layout: {MyAppWeb.Layouts, :app}
    use MyApp.LiveAudit

    unquote(html_helpers())
  end
end
```

And then a cut down version looks like this:

```elixir
defmodule LiveAudit do
  @moduledoc """
  ...
  """

  require Logger

  @typep hook :: 
    :mount | :handle_async | :handle_params 
    | :handle_event | :handle_info | :update,

  @callback audit(hook, hook_data :: %{}) :: 
    {:audit, data_to_record :: %{}} | :ignore

  def handle_audit(:ignore, _view_module), do: :ok

  def handle_audit({:audit, %{} = data_to_audit}, view_module) do
    view_module = 
        view_module |> Atom.to_string() |> String.replace("Elixir.", "")

    params = %{
      params
      | data: Map.put(params.data, :module, view_module)
    }

    AuditModule.record!(params)

    Logger.info("Audit log entry created",
      user_id: params.user_id,
      data: %{
        action: params.action, 
        event: params.data[:event], 
        module: view_module
      }
    )
  end

  defmacro __using__(_opts) do
    quote do
      @behaviour LiveAudit

      def audit(:mount, %{}) do
        raise "You did not define an audit callback for :mount"
      end

      def audit(:update, %{}) do
        raise "You did not define an audit callback for :update"
      end

      # ... same for :handle_event, :handle_async, :handle_info

      defoverridable LiveAudit

      @before_compile {LiveAudit, :mount_audit}
      @before_compile {LiveAudit, :handle_async_audit}
      @before_compile {LiveAudit, :handle_params_audit}
      @before_compile {LiveAudit, :handle_event_audit}
      @before_compile {LiveAudit, :handle_info_audit}
    end
  end

  defmacro mount_audit(_env) do
    quote do
      if Module.defines?(__MODULE__, {:mount, 3}) do
        defoverridable mount: 3

        def mount(params, session, socket) do
          result = super(params, session, socket)

          :mount
          |> __MODULE__.audit(%{
            params: params, 
            session: session, 
            result: result
          })
          |> LiveAudit.handle_audit(socket.view)

          result
        end
      end
    end
  end


  defmacro handle_async_audit(_env) do
    # ...
  end

  defmacro handle_params_audit(_env) do
    # ...
  end

  defmacro handle_event_audit(_env) do
    # ...
  end

  defmacro handle_info_audit(_env) do
    # ...
  end
end
```

So what do we have? Using the `LiveAudit` module inside a live view module does the following

## Adds the `LiveAudit` behavior to the module

This ensures the live view module must define an `audit` function that accepts a hook name in atom form as the first argument and a map as the second.

It returns either an `{:audit, data_to_audit}` tuple or an `:ignore`

That way, every live view module must, no exceptions, explicitly decide whether to audit or not, the outcome of every lifecycle hook. If the function is not defined, a compiler warning will be shown.

## Defines a `handle_audit/2` function

This is the single function we use to record data into an audit log. Everything else will be calling this. How we implement this one depends on the app we use this in.

## Wraps the already defined lifecycle callbacks, using `@before_compile`

Lets look once more at the example of wrapping `mount/3`

```elixir
defmacro mount_audit(_env) do
  quote do
    if Module.defines?(__MODULE__, {:mount, 3}) do
      defoverridable mount: 3

      def mount(params, session, socket) do
        result = super(params, session, socket)

        :mount
        |> __MODULE__.audit(%{params: params, session: session, result: result})
        |> LiveAudit.handle_audit(socket.view)
 
        result
      end
    end
  end
end
```

Note that this code is executing within the live view module using `LiveAudit`.

If the module defines a `mount/3` function already, we first make it overridable using `defoverridable`, then define a new such function.

This new function calls the original using `super`, then takes the result, passes it into `__MODULE__.audit/2`, which is the function you must define in your live view module. The result of that is either `:ignore` or `{:audit, data_to_audit}` and this is then piped into `LiveAudit.handle_audit/2` to record the data.

The `mount/3` callback will always be defined in a livew view module, but we use `Module.defines?` for other callbacks, which aren't always there.

## Defines default audit callbacks for every lifecycle hook, 

By that, I mean this part:

```elixir
def audit(:mount, %{}) do
  raise "You did not define an audit callback for :mount"
end

def audit(:update, %{}) do
  raise "You did not define an audit callback for :update"
end

# ... same for :handle_event, :handle_async, :handle_info
```

We don't really, absolutely need these, but many elixir apps have really spammy logs, so unless you do `mix compile --warnings-as-errors` in your CI, that "your behavior is missing an implementation" warning might get lost. This way, as you're developing your app, an error will be raised after a lifecycle hook, if your `audit/2` function is missing.

# How well does it work?

It's a bit boilerplatey, sure, and a lot of the `handle_event` events, or `handle_params`, don't really need to be audited, but it's very effective catch all.

Every new live view we create will be erroring out unless we immediately define an `audit/2` function in it.

This works great as a reminder, but of course, is still easily broken if you just do

```elixir
def audit(_, _), do: :ignore
```

Se we could certainly improve it or approach it differently. 

There are a couple other options that might be a better way to achieve this

## `socket.assigns` / `socket.private`

```elixir
defmacro mount_audit(_env) do
  quote do
    if Module.defines?(__MODULE__, {:mount, 3}) do
      defoverridable mount: 3

      def mount(params, session, socket) do
        {:ok, socket} = super(params, session, socket)

        socket.assigns 
        |> Map.fetch!(:audit) 
        |> LiveAudit.handl_audit(socket.view)

        {:ok, socket}
      end
    end
  end
end
```

With this approach, instead of requiring the behavior that defines an `audit/2` callback, we require every lifecylce hook to assign an audit key to the socket.

It will still error out, but we now have to be explicit for every clause of `mount/3`, `handle_event/3`, etc, rather than just once in a single spot in the livew view module.

There's also potentially less boilerplate, but the audit code we do have to write this way is more scattered and less uniform.

Instead of the socket assigns, in this case, we could also use socket.private, using [`Phoenix.LiveView.put_private`](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#put_private/3). This is no changed-tracked and is in fact a better place to put this data.

## Result tuple

We could also have make the wrappers expect a different kind of response from the original lifecylce hook

For example

```elixir
defmacro mount_audit(_env) do
  quote do
    if Module.defines?(__MODULE__, {:mount, 3}) do
      defoverridable mount: 3

      def mount(params, session, socket) do
        case super(params, session, socket) do
          {:ignore, result} -> 
            result
          {:audit, audit_data, result} -> 
            LiveAudit.handle_audit(audit_data, socket.view)
            result
        end
      end
    end
  end
end
```

This provides similar benefits to `socket.assigns`, or `socket.private` but might be a bit more uniform in how we use it.

Effectively, each lifecylce hook now needs to return a tuple that wraps what would've been the original result or in other words, what was before

```elixir
def mount(_, _, socket) do
  # do stuff
  {:ok, socket}
end
```

is now

```elixir
def mount(_, _, socket) do
  # do stuff
  {:audit, %{foo: "bar"}, {:ok, socket}}
end
```

That would work, but it feels weird to me.


# Conclusion

The original implementation works just fine for us, but I might make the stretch and actually implement the less boilerplatey one, using `socket.private`. It feels like it could be more powerful.

Working on this task had me learn quite a bit about `use` modules in Elixir. The concept of `super` is something I've glossed over in the past, but it's the first time I'm actually looking at it and I'm surprised it's even there. It feels very OOP :).