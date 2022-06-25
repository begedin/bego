defmodule BegoWeb.Page.Work do
  use Phoenix.Component

  alias BegoWeb.UI.Typo
  alias BegoWeb.UI.Layout

  def work(assigns) do
    ~H"""
    <Layout.column_1>
      <Typo.h1>Do you want to work with me?</Typo.h1>
      <Typo.p>Unfortunately, I am to busy with existing clients at the moment.</Typo.p>
      <Typo.p>
        Feel free to reach out to me for collaboration on things in the Elixir,
        or Vue commmunity, if you need smaller-volume consulting, etc.</Typo.p>
      <Typo.p>
        My socials and contact info are listed in the footer.</Typo.p>
    </Layout.column_1>
    """
  end
end
