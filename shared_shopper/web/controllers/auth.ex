defmodule SharedShopper.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Plug.Conn
  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user, :access)
  end
  def login_by_username_and_pass(conn, username, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(SharedShopper.User, username: username)
    cond do
      user && checkpw(given_pass, user.password_digest) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end
end
