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
        Unfortunately for you, but fortunately for me, my available time is
        already overscheduled.
      </Typo.p>
      <Typo.p>
        Feel free to reach out to me for collaboration on things in the Elixir,
        or Vue commmunity, if you need smaller-volume consulting, etc., but i
        can't commit to any serious work.
      </Typo.p>
      <Typo.p>
        My socials and contact info are listed in the footer.</Typo.p>
    </Element.card>
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
