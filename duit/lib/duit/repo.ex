defmodule Duit.Repo do
  use Ecto.Repo,
    otp_app: :duit,
    adapter: Ecto.Adapters.Postgres
end
