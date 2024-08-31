defmodule BegoWeb.Page.Work do
  use Phoenix.Component

  alias BegoWeb.UI.Element
  alias BegoWeb.UI.Layout
  alias BegoWeb.UI.Typo

  def work(assigns) do
    ~H"""
    <Layout.column_1>
      <.prompt {assigns} />
      <.prior_work {assigns} />
    </Layout.column_1>
    """
  end

  defp prompt(assigns) do
    ~H"""
    <Element.card>
      <Typo.h1>Do you want to work with me?</Typo.h1>
      <Typo.p>
        I am currently fully booked, so I'm not looking for new clients at the
        moment.
      </Typo.p>
      <Typo.p>
        However, feel free to
        <Typo.a href="mailto:begedinnikola+bego.dev@gmail.com">reach out</Typo.a>
        to me for collaboration on things in the Elixir, or Vue commmunity, as well as for lower
        volume consulting in the range of a few hours total.
      </Typo.p>
      <Typo.p>
        My socials and contact info are listed in the footer.
      </Typo.p>
      <Typo.h2>Pricing</Typo.h2>
      <Typo.p>
        My typical hourly rates are negotiable,
        but <strong class="font-bold">start at $60/hour</strong> or the
        equivalent in your preferred currency. Daily or per-project rates are
        also possible.
      </Typo.p>
      <Typo.h2>Services</Typo.h2>
      <dl>
        <.definition>
          <:term>Project planning & leading</:term>
          <:description>
            Helping you plan the development of your product or feature from start to finish, from a technical aspect.
          </:description>
        </.definition>
        <.definition>
          <:term>Development of new software features</:term>
          <:description>
            Developing new, previously planned features of your product, from start to finish.
            I will advise on technical feasibility and communicate findings at every step of the
            process. Work can be independent or as part of a team.
          </:description>
        </.definition>
        <.definition>
          <:term>Performance tuning and code quality improvements</:term>
          <:description>
            Analysing, suggesting and performing improvements to your product and your product's code quality.
          </:description>
        </.definition>
        <.definition>
          <:term>Test automation</:term>
          <:description>Adding or improving the existing testing framework of you product</:description>
        </.definition>
        <.definition>
          <:term>Technical consulting</:term>
          <:description>
            Advising and training you team on all technical expertise covered by other services I offer
          </:description>
        </.definition>
      </dl>
    </Element.card>
    """
  end

  defp definition(assigns) do
    ~H"""
    <dt class="text-gray-900 text-md font-bold"><%= render_slot(@term) %></dt>
    <dd class="mb-1line last:mb-0"><%= render_slot(@description) %></dd>
    """
  end

  defp prior_work(assigns) do
    ~H"""
    <Element.card>
      <Layout.column_1>
        <Typo.h1>Work I Took Part In</Typo.h1>
        <.darwin />
        <.pmn />
        <.this />
      </Layout.column_1>
    </Element.card>
    """
  end

  defp darwin(assigns) do
    ~H"""
    <Element.section>
      <Typo.h2>V7 Darwin</Typo.h2>
      <Typo.a href="https://www.v7labs.com">v7labs.com</Typo.a>
      <Typo.p>
        Long term project developing a machine-learning platform. Starting as
        a backend engineer, moved on to full stack, currently consulting under a
        tech-lead role.
      </Typo.p>
    </Element.section>
    """
  end

  defp pmn(assigns) do
    ~H"""
    <Element.section>
      <Typo.h2>PrayMoreNovenas</Typo.h2>
      <Typo.a href="https://www.praymorenovenas.com">praymorenovenas.com</Typo.a>
      <Typo.p>
        Serving over one million users on a heroku standard-2 instance.
        Sending over 15 million emails per month.
        I'm responsible for > 90% of the codebase.
      </Typo.p>
    </Element.section>
    """
  end

  defp this(assigns) do
    ~H"""
    <Element.section>
      <Typo.h2>This Website</Typo.h2>
      <Typo.p>
        Written in Elixir, built with the Phoenix Framework,
        running on a hobby fly.io instance. Using Tailwind.
      </Typo.p>
    </Element.section>
    """
  end
end
