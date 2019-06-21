defmodule NilmWeb.Router do
  use NilmWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :fetch_session
    plug :accepts, ["json"]
  end

  scope "/", NilmWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/hello", NilmController, :index
    get "/hello/:message", NilmController, :show
  end

  # Other scopes may use custom stacks.
  scope "/api", NilmWeb do
    pipe_through :api

    resources "/users", UserController
    post "/users/login", UserController, :login
    resources "/posts", PostController
  end
end
