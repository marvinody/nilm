defmodule NilmWeb.UserController do
  use NilmWeb, :controller
  alias Nilm.Repo
  alias Nilm.User
  alias NilmWeb.Utils

  import Ecto.Query

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def me(conn, params) do
    Utils.get_user_id(conn, params)
    |> get_self
    |> render_self
  end

  def show(conn, params) do
    case Integer.parse(params["id"]) do
      :error ->
        get_user(conn, %{"name" => params["id"]})
        |> load_posts
        |> render_user

      {_, _} ->
        get_user(conn, params)
        |> load_posts
        |> render_user
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

  def login(conn, %{"name" => name, "password" => password}) do
    case User.authenticate_user(name, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> render("show.json", user: user)

      {:error, error} ->
        conn
        |> put_status(:bad_request)
        |> render("errors.json", errors: [error])
    end
  end

  defp get_user(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil ->
        {:error, conn, ["No such user"]}

      user ->
        {:ok, conn, user}
    end
  end

  defp get_user(conn, %{"name" => name}) do
    case Repo.get_by(User, name: name) do
      nil ->
        {:error, conn, ["No such user"]}

      user ->
        {:ok, conn, user}
    end
  end

  defp get_self({:error, conn, message}), do: {:error, conn, message}

  defp get_self({:ok, conn, %{"user_id" => id}}) do
    case Repo.get(User, id) do
      nil ->
        {:error, conn, ["Please login to do that"]}

      user ->
        {:ok, conn, user}
    end
  end

  defp load_posts({:error, conn, message}), do: {:error, conn, message}

  defp load_posts({:ok, conn, user}) do
    {:ok, conn, Repo.preload(user, :posts)}
  end

  defp render_self(result) do
    case result do
      {:ok, conn, user} ->
        render(conn, "user.json", user: user)

      {:error, conn, errors} ->
        render(conn, "errors.json", errors: errors)
    end
  end

  defp render_user(result) do
    case result do
      {:error, conn, errors} ->
        put_status(conn, :not_found)
        render(conn, "errors.json", errors: errors)

      {:ok, conn, user} ->
        render(conn, "show_full.json", user: user)
    end
  end
end
