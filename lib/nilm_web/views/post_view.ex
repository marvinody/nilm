defmodule NilmWeb.PostView do
  use NilmWeb, :view

  def render("show.json", %{post: post}) do
    render_one(post, NilmWeb.PostView, "post.json")
  end

  def render("errors.json", %{errors: errors}) do
    %{
      errors: errors
    }
  end

  def render("error.json", %{error: error}) do
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
