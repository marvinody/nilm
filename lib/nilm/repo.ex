defmodule Nilm.Repo do
  use Ecto.Repo,
    otp_app: :nilm,
    adapter: Ecto.Adapters.Postgres
end
