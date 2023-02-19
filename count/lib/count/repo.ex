defmodule Count.Repo do
  use Ecto.Repo,
    otp_app: :count,
    adapter: Ecto.Adapters.Postgres
end
