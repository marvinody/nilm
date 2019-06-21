defmodule NilmWeb.PostView do
  use NilmWeb, :view

  def render("show.json", %{post: post}) do
    render_one(post, NilmWeb.PostView, "post.json")
  end

  def render("errors.json", %{changeset: changeset}) do
    %{
      errors:
        Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
          Enum.reduce(opts, msg, fn {key, value}, acc ->
            String.replace(acc, "%{#{key}}", to_string(value))
          end)
        end)
        |> Enum.map(fn {key, errs} ->
          Atom.to_string(key) <> " " <> Enum.join(errs, " ")
        end)
    }
  end

  def render("errors.json", %{error: error}) do
    %{errors: [error]}
  end

  def render("post.json", %{post: post}) do
    %{
      title: post.title,
      id: post.id,
      body: post.body
    }
  end
end
