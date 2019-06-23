defmodule NilmWeb.PostController do
  use NilmWeb, :controller
  alias Nilm.Repo
  alias Nilm.Post
  alias NilmWeb.Utils
  import Ecto.Query

  def index(conn, _params) do
    posts = Repo.all(from p in Post, preload: [:author])
    render(conn, "index.json", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Post, id) do
      nil ->
        render(conn, "errors.json", errors: ["No such post"])

      post ->
        render(conn, "show.json", post: post)
    end
  end

  def create(conn, params) do
    Utils.get_user_id(conn, params)
    |> make_post_changeset
    |> insert_post
    |> load_user
    |> render_post
  end

  defp make_post_changeset({:error, conn, message}), do: {:error, conn, message}

  defp make_post_changeset({:ok, conn, params}) do
    {:ok, conn,
     Post.changeset(%Post{}, %{
       title: params["title"],
       body: params["body"],
       author_id: params["user_id"]
     })}
  end

  defp insert_post({:error, conn, message}), do: {:error, conn, message}

  defp insert_post({:ok, conn, changeset}) do
    case Repo.insert(changeset) do
      {:ok, post} ->
        {:ok, conn, post}

      {:error, changeset} ->
        {:error, conn, NilmWeb.Utils.errorify(changeset)}
    end
  end

  defp load_user({:error, conn, message}), do: {:error, conn, message}

  defp load_user({:ok, conn, post}) do
    {:ok, conn, Repo.preload(post, :author)}
  end

  defp render_post(result) do
    case result do
      {:ok, conn, post} ->
        render(conn, "show.json", post: post)

      {:error, conn, errors} ->
        render(conn, "errors.json", errors: errors)
    end
  end
end
