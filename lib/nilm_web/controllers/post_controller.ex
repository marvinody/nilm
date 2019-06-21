defmodule NilmWeb.PostController do
  use NilmWeb, :controller
  alias Nilm.Repo
  alias Nilm.Post

  def index(conn, _params) do
    posts = Repo.all(Post)

    json(conn, posts)
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Post, id) do
      nil ->
        render(conn, "error.json", %{error: "No such post"})

      post ->
        render(conn, "show.json", post: post)
    end
  end

  def create(conn, params) do
    changeset =
      Post.changeset(%Post{}, %{
        title: params["title"],
        body: params["body"]
      })

    case Repo.insert(changeset) do
      {:ok, post} ->
        render(conn, "show.json", post: post)

      {:error, changeset} ->
        render(conn, "errors.json", changeset: changeset)
    end
  end
end
