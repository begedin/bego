defmodule BegoWeb.Page.Posts do
  use Phoenix.Component

  alias BegoWeb.UI.Element
  alias BegoWeb.UI.Layout
  alias BegoWeb.UI.Typo

  alias BegoWeb.Router.Helpers, as: Routes

  def vue_3_list_render_performance(assigns) do
    ~H"""
    <.d3_script/>
    <.examples />
    <.init_script  {assigns} />
    """
  end

  defp d3_script(assigns) do
    ~H"""
    <script src="https://cdnjs.cloudflare.com/ajax/libs/d3/7.8.2/d3.min.js"></script>
    """
  end

  defp examples(assigns) do
    ~H"""
    <Layout.column_1>
    <Typo.h2>Using <Typo.code>Array.prototype.find</Typo.code> as lookup</Typo.h2>
    <Typo.p>This is the simplest approach, really.</Typo.p>
    <Typo.p>
      No fancy building up of lookup maps, or anything of the sort.
      Just an array of items, with a lookup using <Typo.code>Array.prototype.find</Typo.code>.
    </Typo.p>
    <div id="exampleSimple"></div>

    <Typo.h2>Using a computed lookup map</Typo.h2>
    <Typo.p>
      When not using child components for items, this is expected to behave
      exactly the same as first approach, but with child components, we should
      see some differences.
    </Typo.p>

    <div id="exampleComputed"></div>

    <Typo.h2>Using a manually built lookup map</Typo.h2>
    <div id="exampleRef"></div>


    <div id="aggregate"></div>
    </Layout.column_1>
    """
  end

  defp init_script(assigns) do
    ~H"""
    <script src={Routes.static_path(@conn, "/assets/vue3ListRenderPerformance.js")}></script>
    """
  end
end
