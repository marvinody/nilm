defmodule NilmWeb.PageController do
  use NilmWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
