defmodule NilmWeb.UserController do
  use NilmWeb, :controller
  alias Nilm.Repo
  alias Nilm.User

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil ->
        render(conn, "errors.json", errors: ["No such user"])

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
        conn = put_session(conn, :user_id, user.id)
        render(conn, "show.json", user: user)

      {:error, changeset} ->
        render(conn, "errors.json", errors: errorify(changeset))
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case User.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> render("show.json", user: user)

      {:error, error} ->
        render(conn, "errors.json", errors: [error])
    end
  end

  defp errorify(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {key, errs} ->
      Atom.to_string(key) <> " " <> Enum.join(errs, " ")
    end)
  end
end
