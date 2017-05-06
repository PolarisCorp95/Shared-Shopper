defmodule SharedShopper.SessionController do
  use SharedShopper.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end
end
