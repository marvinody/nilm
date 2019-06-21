defmodule Nilm.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nilm.Post

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    has_many :posts, Post

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
  end

  # catch all if not valid
  defp put_password_hash(changeset) do
    changeset
  end
end
