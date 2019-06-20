defmodule NilmWeb.UserController do
  use NilmWeb, :controller
  alias Nilm.Repo
  alias Nilm.User

  def index(conn, _params) do
    users = Repo.all(User)

    json(conn, users)
  end

  def create(conn, params) do
    changeset =
      User.changeset(%User{}, %{
        email: params["email"],
        name: params["name"],
        bio: params["bio"]
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

  def show(conn, %{"message" => message}) do
    render(conn, "show.html", message: message)
  end
end
