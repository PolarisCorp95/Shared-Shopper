defmodule SharedShopper.UserController do
  use SharedShopper.Web, :controller
  #plug :authorize_user when action in [:edit, :update, :delete]
  alias SharedShopper.User
  alias SharedShopper.Role

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    roles = Repo.all(Role)
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset, roles: roles)
  end

  def create(conn, %{"user" => user_params}) do
    roles = Repo.all(Role)
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> SharedShopper.Auth.login(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, roles: roles)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user)
    cond do
      user == Guardian.Plug.current_resource(conn) || !SharedShopper.RoleChecker.is_admin?(user) ->
        conn
        |> render("show.html", user: user, changeset: changeset)
      :error ->
        conn
        |> put_flash(:info, "No access")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    roles = Repo.all(Role)
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset, roles: roles)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user_params = Map.put_new(user_params, "people", nil)
    roles = Repo.all(Role)
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)
    cond do
      user == Guardian.Plug.current_resource(conn) || !SharedShopper.RoleChecker.is_admin?(user) ->
      case Repo.update(changeset) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: user_path(conn, :show, user))
        {:error, changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset, roles: roles)
      end
      :error1 ->
        conn
        |> put_flash(:info, "No access")
        |> redirect(to: page_path(conn, :index))
    end










  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end


  defp authorize_user(conn, _) do
  user = get_session(conn, :current_user)
  if user && (Integer.to_string(user.id) == conn.params["id"] || SharedShopper.RoleChecker.is_admin?(user)) do
    conn
  else
    conn
    |> put_flash(:error, "You are not authorized to modify that user!")
    |> redirect(to: page_path(conn, :index))
    |> halt()
  end
end

defp authorize_admin(conn, _) do
  user = get_session(conn, :current_user)
  if user && SharedShopper.RoleChecker.is_admin?(user) do
    conn
  else
    conn
    |> put_flash(:error, "You are not authorized to create new users!")
    |> redirect(to: page_path(conn, :index))
    |> halt()
  end
end

end
