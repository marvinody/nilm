defmodule NilmWeb.UserController do
  use NilmWeb, :controller
  alias Nilm.Repo
  alias Nilm.User

  def index(conn, _params) do
    users = Repo.all(User)

    json(conn, users)
  end

  def create(conn, %{"email" => email}) do
    case Repo.insert(%User{email: email}) do
      {:ok, user} ->
        render(conn, "show.json", user: user)

      {:error, error} ->
        IO.puts(error)
    end
  end

  def show(conn, %{"message" => message}) do
    render(conn, "show.html", message: message)
  end
end
