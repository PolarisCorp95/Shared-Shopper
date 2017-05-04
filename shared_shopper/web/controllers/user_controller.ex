defmodule SharedShopper.UserController do
  use SharedShopper.Web, :controller
  alias SharedShopper.User

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end
end
