defmodule NilmWeb.UserView do
  use NilmWeb, :view

  def render("show.json", %{user: user}) do
    %{data: render_one(user, NilmWeb.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      email: user.email
    }
  end
end
