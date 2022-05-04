defmodule Bego.Repo do
  use Ecto.Repo,
    otp_app: :bego,
    adapter: Ecto.Adapters.Postgres
end
