defmodule NilmWeb.Utils do
  use NilmWeb, :controller

  def errorify(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {key, errs} ->
      Atom.to_string(key) <> " " <> Enum.join(errs, " ")
    end)
  end

  def get_user_id(conn, params) do
    case get_session(conn, "user_id") do
      nil ->
        {:error, conn, %{errors: ["Please login to do that"]}}

      user_id ->
        {:ok, conn, Map.put(params, "user_id", IO.inspect(user_id))}
    end
  end
end
