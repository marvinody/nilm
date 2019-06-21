defmodule NilmWeb.PostController do
  use NilmWeb, :controller
  alias Nilm.Repo
  alias Nilm.Post

  def index(conn, _params) do
    posts = Repo.all(Post)
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
    get_user_id(conn, params)
    |> make_post_changeset
    |> insert_post
    |> render_post
  end

  defp get_user_id(conn, params) do
    case get_session(conn, "user_id") do
      nil ->
        {:error, conn, %{errors: ["Please login to do that"]}}

      user_id ->
        {:ok, conn, Map.put(params, "user_id", IO.inspect(user_id))}
    end
  end

  defp make_post_changeset({:error, conn, message}), do: {:error, conn, message}

  defp make_post_changeset({:ok, conn, params}) do
    {:ok, conn,
     Post.changeset(%Post{}, %{
       title: params["title"],
       body: params["body"],
       user_id: params["user_id"]
     })}
  end

  defp insert_post({:error, conn, message}), do: {:error, conn, message}

  defp insert_post({:ok, conn, changeset}) do
    case Repo.insert(changeset) do
      {:ok, post} ->
        {:ok, conn, post}

      {:error, changeset} ->
        {:error, conn, errorify(changeset)}
    end
  end

  defp render_post(result) do
    case result do
      {:ok, conn, post} ->
        render(conn, "show.json", post: post)

      {:error, conn, errors} ->
        render(conn, "errors.json", errors: errors)
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
