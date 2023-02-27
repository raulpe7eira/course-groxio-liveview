defmodule DuitWeb.PageController do
  use DuitWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
