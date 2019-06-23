defmodule NilmWeb.UserController do
  use NilmWeb, :controller
  alias Nilm.Repo
  alias Nilm.User
  alias NilmWeb.Utils

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def me(conn, params) do
    Utils.get_user_id(conn, params)
    |> get_user
    |> render_self
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil ->
        put_status(conn, :not_found)
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
        put_status(conn, :created)
        render(conn, "show.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render("errors.json", errors: Utils.errorify(changeset))
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case User.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> render("show.json", user: user)

      {:error, error} ->
        put_status(conn, :unauthorized)
        render(conn, "errors.json", errors: [error])
    end
  end

  defp get_user({:error, conn, message}), do: {:error, conn, message}

  defp get_user({:ok, conn, %{"user_id" => id}}) do
    case Repo.get(User, id) do
      nil ->
        {:error, conn, ["Please login to do that"]}

      user ->
        {:ok, conn, user}
    end
  end

  defp render_self(result) do
    case result do
      {:ok, conn, user} ->
        render(conn, "user.json", user: user)

      {:error, conn, errors} ->
        render(conn, "errors.json", errors: errors)
    end
  end
end
