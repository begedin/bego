defmodule Makeup.Lexers.TypesscriptLexer.Application do
  @moduledoc false
  use Application

  alias Makeup.Registry
  alias Makeup.Lexers.TypescriptLexer

  def start(_type, _args) do
    Registry.register_lexer(TypescriptLexer,
      options: [],
      names: ["typescript", "ts"],
      extensions: ["ts"]
    )

    Supervisor.start_link([], strategy: :one_for_one)
  end
end
