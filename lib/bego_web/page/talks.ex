defmodule BegoWeb.Page.Talks do
  use Phoenix.Component

  alias BegoWeb.UI.Element
  alias BegoWeb.UI.Layout
  alias BegoWeb.UI.Typo

  def talks(assigns) do
    ~H"""
    <Layout.column_1>
      <.talk title="Migrating a 1000 Class Components App to Vue 3" where="Vue.js Londong 2023">
        <Typo.p><em>Online</em></Typo.p>
        <Typo.p>
          A story of migrating a large Vue 2 app to Vue 3, with a focus on
          the challenges and solutions for dealing with the fact the project
          contained almost exclusively class Components
        </Typo.p>
        <Typo.p>
          <Typo.a href="https://gitnation.com/contents/migrating-a-1000-class-components-app-to-vue-3">
            Link to video and transcript
          </Typo.a>
        </Typo.p>
      </.talk>
      <.talk
        title="Building a Block-Based Editor in PhoenixLiveView"
        where="ElixirConf EU, London 2022"
        youtube="7yZwxsG7tVs"
      >
        <Typo.p>
          Successes and failures in an attempt to build a block-based editor
          in PhoenixLiveView
        </Typo.p>
      </.talk>
      <.talk
        title="Doing Weird Things With Ecto"
        where="ElixirConf EU, Warsaw 2021"
        youtube="zrfZ1GiOc-I"
      >
        <Typo.p>
          Talking about unusual things I ended up doing with Ecto during
          some of my projects
        </Typo.p>
      </.talk>
      <.talk
        title="Setting up E2E testing with Ecto Sandbox Plug (Workshop)"
        where="ElixirConf Africa Virtual, 2021"
      >
        <Typo.p><em>Never released</em></Typo.p>
        <Typo.p>
          A workshop following steps similar to ones from prior talk,
          except this one was follow-along
        </Typo.p>
      </.talk>
      <.talk
        title="E2E Backend testing with Ecto API"
        where="CodeBeam Virtual 2020"
        youtube="OAuTCyvp9NY"
      >
        <Typo.p>
          Step-by-step of how to setup an ecto sandbox for use with external
          APIs, to power cross-project E2E testing
        </Typo.p>
      </.talk>
    </Layout.column_1>
    """
  end

  def talk(assigns) do
    ~H"""
    <Element.card spacing="medium">
      <Typo.h2 class="text-lg font-bold text-emerald-900"><%= @title %></Typo.h2>
      <p>At <em><%= @where %></em></p>
      <%= if assigns[:youtube] do %>
        <Element.video>
          <Element.youtube url={@youtube} title={@title} />
        </Element.video>
      <% end %>
      <%= render_slot(@inner_block) %>
    </Element.card>
    """
  end
end
