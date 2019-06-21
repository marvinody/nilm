defmodule Nilm.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nilm.User

  schema "posts" do
    field :body, :string
    field :title, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title])
  end
end
