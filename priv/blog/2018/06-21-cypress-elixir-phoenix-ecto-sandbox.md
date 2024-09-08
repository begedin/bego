%{
    title: "Setting up an Elixir/Phoenix project for acceptance testing with Cypress",
    author: "@begedinnikola",
    tags: ~w(elixir phoenix ecto cypress testing e2e),
    description: "How to setup a phoenix ecto sandbox for a Cypress E2E suite"
}
---

# What is Cypress?

Cypress is this awesome new tool that works great with APIs and is as easy to setup as anything if you're mocking out your backend.

I've recently moved from Ember to React and I've been missing the test setup for acceptance (or end to end) tests a lot.

What Ember does with ember-cli is that it, right out of the box, give you a command which runs test in an actual browser environment (used to be PhantomJS by default, but is now headless Chrome), where you perform/simulate actual user interaction and make assertions on what happens both in the UI and in the background.

Cypress is an app, with a UI which does something similar, except it works with any framework. Further more, it provides you with an infrastructure which allows you to do even more.

# But what about data?

With Ember, we usually ended up using either a fake server with fake data, or a mock server layer with mock responses to requests. `ember-cli-mirage` usually did the trick for us.

That means that, technically, only our frontend app was acceptance/e2e tested, but there was still no guarantee it works correctly with our backend.

However, now that I started using Cypress and an Elixir/Phoenix backend, I realised I could've and now can easily do more than that.

# Ecto Sandbox mode

Ecto, the data layer/library Phoenix uses, has this thing called a Sandbox mode.

To elaborate, each test in Elixir/ExUnit runs in a separate erlang process. The database layer runs a pool of connections those processes to use to perform actions with the database.

To allow easier management of the data each test accepts, and to allow easier running of these processes in parallel, Ecto provides a thing called a Sandbox mode.

Effectively, each process, or each test, get's it's own sandboxed database, which runs in a single transaction, isolated from other processes, and is canceled when the process exits.

That means that, within the test, we perceive data as changing, but as soon as the test ends, any changes are rolled back.

This isn't on by default, but the process to set it up is relatively simple


```Elixir
# in config/test.exs
config :my_app, MyApp.Repo, pool: Ecto.Adapters.SQL.Sandbox

# in test_helper.ex
Ecto.Adapters.SQL.Sandbox.mode(MyApp.Repo, :manual)

# before each test, or in an ExUnit.Case
setup do
  # Explicitly get a connection before each test
  :ok = Ecto.Adapters.SQL.Sandbox.checkout(MyApp.Repo)
end
```

Really, it's explained quite well in the [Ecto documentation](https://hexdocs.pm/ecto/Ecto.Adapters.SQL.Sandbox.html#module-example).

The problem is, this only works with `ExUnit`, so it only works with backend tests written in Elixir. If your app is a server-rendered backend app, with little to no client code, that's fine. Most of the time, it's not.

Another problem is that the database adapter we're using needs to support this. The two Ecto comes prepackaged with, `Ecto.Adapters.MySQL` and `Ecto.Adapters.Postgres` both support it, with `MySQL` supporting sandbox mode, but not with concurrent processes. For third party adapters, we'll have to look into the documentation, possibly open tickets, or even contribute to an open source project to get it working.

# Ecto Sandbox Mode with a Frontend app

A progressive web application, a dynamic client application, a javascript app, a single page application, call it whatever you like, but most web sites or web apps have quite a lot of client-written behavior, which needs to be tested to and, ideally, those tests need to make sure it works with the current backend, which could easily be a separate project, making any syncing even harder.

Fortunately, `phoenix_ecto` has us covered with a plug called `[Phoenix.Ecto.Sql.Sandbox](https://hexdocs.pm/phoenix_ecto/main.html#concurrent-browser-tests)`

You should read that documentation. In fact, you should read the documentation of any Elixir library you use. The amount of info there is usually sufficient to de anything.

But to elaborate, here's how it works.

First, I create a separate mix environment for running the dev server in sandbox mode. This will have to run in a background process, or in a separate terminal tab, since cypress prefers not to be in charge of starting and shutting down the server.

I like to call this one e2e, so we add `config/e2e.exs`:

```Elixir
# config/e2e.exs

# it's basically a dev environment, with a minor change added to it
import_config "dev.exs"

# this is the minor change
config :my_app, sql_sandbox: true
```

Then, I add a couple of lines to the `MyAppWeb.Endpoint` module:

```Elixir
# lib/my_app_web/endpoint.ex:

use Phoenix.Endpoint, otp_app: :sift

if Application.get_env(:my_app, :sql_sandbox) do
  plug(Phoenix.Ecto.SQL.Sandbox, at: "/sandbox", header: "x-session-id", repo: MyApp.Repo)
end
```

What that does is, if I run my server with `MIX_ENV=e2e mix phx.server`, the router will support two additional actions

- `POST /sandbox` checks out a sandbox connection
- `DELETE /sandbox` checks in a sandbox connection

It also adds a plug layer to all other routes which checks for an `x-session-id` header and assigns the handler for that request the checked out connection.

Get where I'm going with this?

Our frontend testing tool can now

- make a `POST` request to `/sandbox` to check out a sandbox connection and get back an id token at the start of the test
- sign all further requests in that test with an `x-session-id` header, the value of which is that token, to use the checked out sandbox connection
- make a `DELETE` request to `/sandbox`, with an `x-session-id` header, to check in the same sandbox connection at the end of the test

The end result is, our frontend test runs isolated from other frontend tests, while at the same time being able to access your actual backend, instead of using a fake one.

# Setting up Cypress to use a Phoenix backend in Ecto sandbox mode

I'm assuming you've already followed the Getting Started section of the cypress docs. The base API url has been set and everything is ready. Ideally, you already have a test running and hitting our `MIX_ENV=e2e mix phx.server` backend running in another tab, causing that backend to error out due to duplicate date (because Cypress is not triggering sandbox mode).

First thing to note is that even if you set it up now, the tests will still likely fail. You have to do a `MIX_ENV=e2e mix ecto.reset` to clean up the database first.

## Cypress with a Phoenix/Absinthe backend and a React Apollo frontend

This is setup where I've taught myself this procedure.

For checking out and checking in connections, I've created a pair of cypress commands

```js

Cypress.Commands.add('checkoutSession', async () => {
  const response = await fetch('/sandbox', {
    cache: 'no-store',
    method: 'POST',
  });

  const sessionId = await response.text();
  return Cypress.env('sessionId', sessionId);
});

Cypress.Commands.add('dropSession', () =>
  fetch('/sandbox', {
    method: 'DELETE',
    headers: { 'x-session-id': Cypress.env('sessionId') },
  }),
);
```

For signing each request made by the app with an `x-session-id` header, things get a bit tricky. What we need to do is to modify `window.fetch` slightly, since that's what Apollo uses. To do that, we make use of Cypress' ability to inject code into the browser session it runs the test in.

```js
const buildTrackableFetchWithSessionId = fetch => (fetchUrl, fetchOptions) => {
  const { headers } = fetchOptions;
  const modifiedHeaders = Object.assign(
    { 'x-session-id': Cypress.env('sessionId') },
    headers,
  );

  const modifiedOptions = Object.assign({}, fetchOptions, {
    headers: modifiedHeaders,
  });

  return fetch(fetchUrl, modifiedOptions)
};

Cypress.on('window:before:load', win => {
  cy.stub(win, 'fetch', buildTrackableFetchWithSessionId(fetch));
});
```

What we did is we wrapped our `window.fetch` into a function which adds the necessary header to each request.

Now, this is a tad complex. Ideally, we would make use of `cy.server` somehow, but I was unable to figure out out yet. If I do, or if someone else does, I'll be sure to post an update.

There's another caveat we need to solve here that makes it slightly more complex.

Our cypress test has no idea when it can end, so it also needs to wait for all outgoing requests to resolve or fail before starting checking the session back in. Otherwise, we might encounter trouble.

This works automatically for Cypress with XHR requests, but for requests made through the Fetch API, it fails, so we need to make our code a tad more complex.

```js
const increaseFetches = () => {
  const count = Cypress.env('fetchCount') || 0;
  Cypress.env('fetchCount', count + 1);
};

const decreaseFetches = () => {
  const count = Cypress.env('fetchCount') || 0;
  Cypress.env('fetchCount', count - 1);
};

const buildTrackableFetchWithSessionId = fetch => (fetchUrl, fetchOptions) => {
  const { headers } = fetchOptions;
  const modifiedHeaders = Object.assign(
    { 'x-session-id': Cypress.env('sessionId') },
    headers,
  );

  const modifiedOptions = Object.assign({}, fetchOptions, {
    headers: modifiedHeaders,
  });

  return fetch(fetchUrl, modifiedOptions)
    .then(result => {
      decreaseFetches();
      return Promise.resolve(result);
    })
    .catch(result => {
      decreaseFetches();
      return Promise.reject(result);
    });
};

Cypress.on('window:before:load', win => {
  cy.stub(win, 'fetch', buildTrackableFetchWithSessionId(fetch));
});
```

What we do is keep a counter of active Fetch API requests in `Cypress.env`. We have a special command we then use to wait for all of them to run their course before checking the session back in.

```js
Cypress.Commands.add('waitForFetches', () => {
  if (Cypress.env('fetchCount') <= 0) {
    return;
  }

  cy.wait(100).then(() => cy.waitForFetches());
});
```

The command waits in 100 ms increments to see if the fetch count dropped to zero. I found it completely reliable for my usage, but tweaks may be required.

The easiest way to put this command to use is to rewrite our `dropSession` command.

```js
Cypress.Commands.add('dropSession', () =>
  cy.waitForFetches().then(() =>
    fetch('/api/sandbox', {
      method: 'DELETE',
      headers: { 'x-session-id': Cypress.env('sessionId') },
    }),
  ),
);
```

As an alternative for request waiting, we could have the `ApolloClient` not use `Fetch` in a test environment, but then we're forced to scatter our custom test-code around, while this approach can keep it in one place.

Ideally, at some point Cypress will know to wait for outgoing Fetch API requests to and we can just remove this complexity.

# Cypress with a Phoenix JSON API backend and a React REST frontend

Really, the approach here is near identical to the GraphQL approach, except, if the network layer of the app uses XHR instead of Fetch, we don't need to maintain a fetch counter and tests will wait properly by default.

In that case, instead of overriding fetch, we would override the `XMLHttpRequest.prototype.open` function.

I didn't get a chance to actually test this, but the general approach would be something like:

```js
const overrideOpen = original => {
  return function openWithHeaders() {
    original.apply(this, arguments);
    this.setRequestHeader('x-session-id', Cypress.env('sessionId'));
  };
};

Cypress.on('window:before:load', win => {
  cy.stub(
    win,
    'XMLHttpRequest.prototype.open',
    overrideOpen(XMLHttpRequest.prototype.open)
  );
});
```

# Tip: Pre-creating data for tests to use

We can use different approaches here. One is to use `cy.task()` to execute outside code and seed the database that way. Another is to simply use the data layer our app likely already has and make direct requests for data creation to the API, after we've checked out the session, but before the actual test started running.

For example, with GraphQL, I created a `cy.mutate(mutation, variables)` command:

```js
Cypress.Commands.add('mutate', (mutation, variables) => {
  const client = buildClient({
    'x-session-id': Cypress.env('sessionId')
  });
  return client.mutate({ mutation, variables });
});
```

My `buildClient` function is the same I use in my app to build an `ApolloClient`. It allows me to pass in custom headers for all requests to use, which is what I do here.
