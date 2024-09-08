%{
    title: "Persisting state between page loads on the backend with Elixir/Phoenix",
    author: "@begedinnikola",
    tags: ~w(elixir phoenix ecto genserver),
    description: "A (now outdated) method of persisting state between backend-rendered pages using a GenServer"
}
---

## What's the idea?

Say you have a signup process that's more onboarding than account creation.

The user submits information in multiple steps, where the next step depends on the contents of the previous step, etc.

You also don't have an advanced frontend. It's just a basic server-based application, so each step means navigating to a different page

What if the user gives up half way through? How do you deal with that?

Suddenly, you are left with a partially created account.

Maybe that partial data is useless to you and you want to clean it up? Maybe you want to do something about it? Send an email? Perform some task?

Ideally, you don't save anything into the database yet, because why waste resources. However, you do keep it somewhere where it's cheap and easy to retrieve.

Then, when the user is all done, you save the data. When you detect the user gave up, you do something about it without having to sanitise anything in the database.

### Do it with a `GenServer`!

Elixir has a `GenServers` and they're simple to use for any of those tasks you want to do. In fact, they even make it easy to create a multi-step process in the first place!

## How?

Let's generate a basic app called **"wizard"**, where a user creates their account and workspace.

```
mix phx.new wizard --no-ecto
```

We don't need a repository for the purposes of demonstrating the concept, thus, `--no-ecto`.

Next up, we add some routes for our onboarding flow

```Elixir
get "/step-1", WizardController, :step_1
post "/step-1", WizardController, :next_step
get "/step-2", WizardController, :step_2
post "/step-2", WizardController, :submit_steps
get "/doublecheck", WizardController, :doublecheck
```

And then we also add our controller.

I could've used a generator for all this, but I didn't, and you can copy paste, so it's fine!

```Elixir

# lib/wizard_web/controllers/wizard_controller.ex

defmodule WizardWeb.WizardController do
  use WizardWeb, :controller

  alias Wizard.Onboarding

  def step_1(conn, _params) do
    conn |> render("step_1.html")
  end

  def submit_step_1(conn, params) do
    conn.remote_ip |> Onboarding.submit_account(params)
    conn |> redirect(to: conn |> wizard_path(:step_2))
  end

  def step_2(conn, _params) do
    conn |> render("step_2.html")
  end

  def submit_step_2(conn, params) do
    conn.remote_ip |> Onboarding.submit_workspace(params)
    conn |> redirect(to: conn |> wizard_path(:doublecheck))
  end

  def doublecheck(conn, _params) do
    {account_params, workspace_params} =
      conn.remote_ip |> Onboarding.get_data()

    conn
    |> render(
      "doublecheck.html",
      account_params: account_params,
      workspace_params: workspace_params
    )
  end
end

```

The idea is, the `step_1` action renders a form. The user then submits the form, calling the `submit_step_1` action.

`submit_step_1` sends the submitted parameters to our `GenServer`, which stores them.

Similarly, `step_2` renders another form, which submits another set of parameters with `submit_step_2`, which also stores those parameters to the `GenServer`.

Then, we end up on redirected to the `doublecheck` action, where we retrieve both sets of parameters and render our template with those as the assigns.

For demo purposes, the template does nothing else other than rendering the parameters.

All 3 calls to the `GenServer` send `conn.remote_ip` as the first argument. The server uses the IP as a key to stare the data on a per-user basis.

Here's what the `GenServer` looks like:

```Elixir
# lib/wizard/onboarding.ex
defmodule Wizard.Onboarding do
  @name __MODULE__

  use GenServer

  # API

  def start_link() do
    GenServer.start_link(@name, [], name: @name)
  end

  def submit_account(ip, params) do
    GenServer.cast(@name, {:submit_account, ip, params})
  end

  def submit_workspace(ip, params) do
    GenServer.cast(@name, {:submit_workspace, ip, params})
  end

  def get_data(ip) do
    GenServer.call(@name, {:get_data, ip})
  end

  # Callbacks

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:submit_account, ip, params}, %{} = state) do
    # keep old workspace params, update account params
    new_state =
      state
      |> Map.update(ip, {nil, nil}, fn {_, workspace_params} ->
        {params, workspace_params}
      end)

    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:submit_workspace, ip, params}, %{} = state) do
    # keep old account params, update workspace params
    new_state =
      state
      |> Map.update(ip, {nil, nil}, fn {account_params, _} ->
        {account_params, params}
      end)

    {:noreply, new_state}
  end

  @impl true
  def handle_call({:get_data, ip}, _from, %{} = state) do
    {:reply, state[ip], state}
  end
end

```

Again, emphasis on simplicity for this demo.

Out `state` is a map and we use the IP as the key for storing individual bits of data.

The value for each IP is a tuple, the first element of which are the account params submitted in step 1 and the second element the workspace params submitted in step 2.

Note that using the IP as the data key probably isn't ideal, but again, this is about the idea, not the real life execution.

For the sake of getting this running as soon as possible, this is our view and respective templates:

```Elixir
# lib/wizard_web/views/wizard_view
defmodule WizardWeb.WizardView do
  use WizardWeb, :view
end
```

Nothing special about that.

```elixir
# lib/wizard_web/templates/wizard/step_1.html.eex
<h3>Step 1: Your personal info</h3>
<%= form_for @conn, @conn |> wizard_path(:submit_step_1), fn f -> %>
  <div class="form-group">
    <%= label(f, :email) %>
    <%= text_input(f, :email, class: "form-control") %>
  </div>
  <div class="form-group">
    <%= label(f, :full_name) %>
    <%= text_input(f, :full_name, class: "form-control") %>
  </div>
  <div class="form-group">
    <%= submit("Next", class: "btn btn-primary pull-right") %>
  </div>
<% end %>

# lib/wizard_web/templates/wizard/step_1.html.eex
<h3>Step 2: Your workspace info</h3>
<%= form_for @conn, @conn |> wizard_path(:submit_step_2), fn f -> %>
  <div class="form-group">
    <%= label(f, :name) %>
    <%= text_input(f, :name, class: "form-control") %>
  </div>
  <div class="form-group">
    <% back_path = @conn |> wizard_path(:step_1) %>
    <%= link("Back", to: back_path, class: "btn btn-default") %>
    <%= submit("Doublecheck", class: "btn btn-success pull-right") %>
  </div>
<% end %>

# lib/wizard_web/templates/wizard/doublecheck.html.eex
<h3>This is the data you submitted:</h3>
<h4>Account</h4>
<pre>
  <%= @account_params |> Kernel.inspect(pretty: true) %>
</pre>

<h4>Workspace</h4>
<pre>
  <%= @workspace_params |> Kernel.inspect(pretty: true) %>
</pre>

<% back_path = @conn |> wizard_path(:step_2) %>
<%= link("Back", to: back_path, class: "btn btn-default") %>
```

As I said, the steps are forms, while the final step is a basic page that renders the data we have.

## Where to from here?

In a real world scenario, each step would do something more. For example, individual submit steps could cast changesets or process the data in some way.

The controller could cast data into changesets and render validation errors, storing valid changesets into the `GenServer`, instead of raw parameters.

As a final step, we would also have some sort of call which actually persists the data, but as I said, this is about the idea.

The possibilities should be clear, though. **It's trivial to manage state during user interaction and between page navigations using a `GenServer`.**

## Going even further...

[LiveViews are soon to become a thing.](https://www.youtube.com/watch?v=Z2DU0qLfPIY)

In the meantime, you could use the same `GenServer`, in conjunction with phoenix channels, to inform the user about any long running tasks in the onboarding process in real time.

Who says you need to use this in a primarily server-based app? Imagine the possibilities!
