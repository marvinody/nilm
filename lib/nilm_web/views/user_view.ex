defmodule NilmWeb.UserView do
  use NilmWeb, :view

  def render("index.json", %{users: users}) do
    render_many(users, NilmWeb.UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, NilmWeb.UserView, "user.json")
  end

  def render("errors.json", %{errors: errors}) do
    %{
      errors: errors
    }
  end

  def render("user.json", %{user: user}) do
    %{
      email: user.email,
      id: user.id,
      name: user.name
    }
  end
end
