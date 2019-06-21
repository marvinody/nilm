defmodule Nilm.User do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias Nilm.Post
  alias Nilm.User
  alias Nilm.Repo

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

  def authenticate_user(email, password) do
    query = from(u in User, where: u.email == ^email)

    query
    |> Repo.one()
    |> verify_password(password)
  end

  defp verify_password(nil, _) do
    Bcrypt.no_user_verify()
    {:error, "Wrong email or password"}
  end

  defp verify_password(user, password) do
    case Bcrypt.verify_pass(password, user.password_hash) do
      true ->
        {:ok, user}

      false ->
        {:error, "Wrong email or password"}
    end
  end
end
