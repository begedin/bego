defmodule BegoWeb.Page.OpenSource do
  use Phoenix.Component

  alias BegoWeb.UI.Element
  alias BegoWeb.UI.Layout
  alias BegoWeb.UI.Typo

  def open_source(assigns) do
    ~H"""
    <Layout.column_1>
      <Element.card>
        <Typo.h1>
          Open Source Work
        </Typo.h1>
        <Typo.p>
          I have contributions to several open source projects and also own a
          few of my own. Listed here are the more notable ones.
        </Typo.p>
      </Element.card>
      <Element.card>
        <Typo.h2>StripityStripe</Typo.h2>
        <Typo.p>
          I've been a long term maintainer, but not recently,
          of the primary elixir library work working with the Stripe API
        </Typo.p>
        <Typo.a href="https://github.com/beam-community/stripity-stripe">
          StripityStripe on GitHub
        </Typo.a>
      </Element.card>
      <Element.card>
        <Typo.h2>Philtre</Typo.h2>
        <Typo.p>
          An development block-based editor written in Phoenix Live View
        </Typo.p>
        <Typo.a href="https://github.com/begedin/philtre">
          Philtre on GitHub
        </Typo.a>
      </Element.card>
      <Element.card>
        <Typo.h2>Elixir SparkPost</Typo.h2>
        <Typo.p>
          An unofficial fork of the somewhat official elixir library for the
          SparkPost email API. Currently more feature-full than the official
          library, with the aim to more than surpass it.
        </Typo.p>
        <Typo.a href="https://github.com/begedin/elixir-sparkpost">
          ElixirSparkpost on GitHub
        </Typo.a>
      </Element.card>
    </Layout.column_1>
    """
  end
end
