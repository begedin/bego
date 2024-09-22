defmodule BegoWeb.Page.Index do
  use Phoenix.Component

  alias BegoWeb.UI.Element
  alias BegoWeb.UI.Layout
  alias BegoWeb.UI.Typo

  def index(assigns) do
    ~H"""
    <Layout.column_1>
      <Element.card>
        <Typo.h1>
          Bego Solutions is an LLC sole proprietorship owned by myself, Nikola Begedin
        </Typo.h1>
        <Typo.p>
          I work with small to medium sized teams, or by myself, to deliver the
          product you need.
        </Typo.p>
      </Element.card>
      <Element.card>
        <Typo.h2>Quality and maintainability</Typo.h2>
        <Typo.p>
          I will deliver the product you requested, but if you prefer,
          you can hire someone else to maintain it.
          The product is yours amd will be delivered with the necessary
          tests and documentation, so anyone can take over.
        </Typo.p>
      </Element.card>
      <Element.card>
        <Typo.h2>Communication and openness</Typo.h2>
        <Typo.p>
          Things don't always go to plan, but you will know how and why,
          and you will be given options and information you need early enough
          to decide how to respond to problems.
        </Typo.p>
      </Element.card>
    </Layout.column_1>
    """
  end
end
