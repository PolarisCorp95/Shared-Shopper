defmodule SharedShopper.TodoController do
  use SharedShopper.Web, :controller
  alias SharedShopper.Todo
  alias SharedShopper.Shoppinglist
  plug :scrub_params, "todo" when action in [:create, :update]
  plug :set_shoppinglist_and_authorize_user when action in [:update, :delete]

  def create(conn, %{"todo" => todo_params, "shoppinglist_id" => shoppinglist_id}) do
    shoppinglist = Repo.get!(Shoppinglist, shoppinglist_id) |> Repo.preload([:user, :todos])
    changeset = shoppinglist
      |> build_assoc(:todos)
      |> Todo.changeset(todo_params)

    case Repo.insert(changeset) do
      {:ok, _todo} ->
        conn
        |> put_flash(:info, "Todo created successfully!")
        |> redirect(to: user_shoppinglist_path(conn, :show, shoppinglist.user, shoppinglist))
      {:error, changeset} ->
        render(conn, SharedShopper.ShoppinglistView, "show.html", shoppinglist: shoppinglist, user: shoppinglist.user, todo_changeset: changeset)
    end
  end


  def update(conn, %{"id" => id, "shoppinglist_id" => shoppinglist_id, "todo" => todo_params}) do
    shoppinglist = Repo.get!(Shoppinglist, shoppinglist_id) |> Repo.preload(:user)
    todo = Repo.get!(Todo, id)
    changeset = Todo.changeset(todo, todo_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Todo updated successfully.")
        |> redirect(to: user_shoppinglist_path(conn, :show, shoppinglist.user, shoppinglist))
      {:error, _} ->
        conn
        |> put_flash(:info, "Failed to update comment!")
        |> redirect(to: user_shoppinglist_path(conn, :show, shoppinglist.user, shoppinglist))
    end
  end

  def delete(conn, %{"id" => id, "shoppinglist_id" => shoppinglist_id}) do
    shoppinglist = Repo.get!(Shoppinglist, shoppinglist_id) |> Repo.preload(:user)
    Repo.get!(Todo, id) |> Repo.delete!
    conn
    |> put_flash(:info, "Deleted Todo!")
    |> redirect(to: user_shoppinglist_path(conn, :show, shoppinglist.user, shoppinglist))
  end

  defp set_shoppinglist(conn) do
    shoppinglist = Repo.get!(Shoppinglist, conn.params["shoppinglist_id"]) |> Repo.preload(:user)
    assign(conn, :shoppinglist, shoppinglist)
  end

  defp set_shoppinglist_and_authorize_user(conn, _opts) do
    conn = set_shoppinglist(conn)
    if is_authorized_user?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to modify that todo!")
      |> redirect(to: page_path(conn, :index))
      |> halt
    end
  end

  defp is_authorized_user?(conn) do
    user = get_session(conn, :current_user)
    shoppinglist = conn.assigns[:shoppinglist]
    user && (user.id == shoppinglist.user_id) || SharedShopper.RoleChecker.is_admin?(user)
  end

end
