defmodule NilmWeb.UserController do
  use NilmWeb, :controller
  alias Nilm.Repo
  alias Nilm.User

  def index(conn, _params) do
    users = Repo.all(User)

    json(conn, users)
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil ->
        render(conn, "error.json", %{error: "No such user"})

      user ->
        render(conn, "show.json", user: user)
    end
  end

  def create(conn, params) do
    changeset =
      User.changeset(%User{}, %{
        email: params["email"],
        name: params["name"],
        password: params["password"]
      })

    case Repo.insert(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)

      {:error, changeset} ->
        IO.puts("CHANGESET")
        IO.inspect(changeset)

        render(conn, "errors.json", changeset: changeset)
    end
  end
end
