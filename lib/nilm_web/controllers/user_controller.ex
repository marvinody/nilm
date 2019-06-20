defmodule NilmWeb.UserController do
  use NilmWeb, :controller
  alias Nilm.Repo
  alias Nilm.User

  def index(conn, _params) do
    users = Repo.all(User)

    json(conn, users)
  end

  def show(conn, %{"message" => message}) do
    render(conn, "show.html", message: message)
  end
end
