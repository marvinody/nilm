defmodule NilmWeb.PostView do
  use NilmWeb, :view

  def render("index.json", %{posts: posts}) do
    render_many(posts, NilmWeb.PostView, "post.json")
  end

  def render("show.json", %{post: post}) do
    render_one(post, NilmWeb.PostView, "post.json")
  end

  def render("errors.json", %{errors: errors}) do
    %{
      errors: errors
    }
  end

  def render("post.json", %{post: post}) do
    %{
      title: post.title,
      id: post.id,
      body: post.body,
      user_id: post.user_id
    }
  end
end
