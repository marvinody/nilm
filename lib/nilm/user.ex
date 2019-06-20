defmodule Nilm.User do
  use Ecto.Schema
  import Ecto.Changeset

  # @derive {Jason.Encoder, only: [:email]}
  schema "users" do
    field :bio, :string
    field :email, :string
    field :name, :string

    timestamps()
  end

  def all(user) do
    Jason.encode(user, only: [:email])
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :bio])
    |> validate_required([:name, :email])
  end
end
