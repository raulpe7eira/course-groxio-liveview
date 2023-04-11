defmodule Bigr.Repo do
  use Ecto.Repo,
    otp_app: :bigr,
    adapter: Ecto.Adapters.Postgres
end
