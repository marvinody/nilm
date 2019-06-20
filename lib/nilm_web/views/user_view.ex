defmodule NilmWeb.UserView do
  use NilmWeb, :view

  def render("show.json", %{user: user}) do
    %{data: render_one(user, NilmWeb.UserView, "user.json")}
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

  def render("user.json", %{user: user}) do
    %{
      email: user.email,
      name: user.name
    }
  end
end
