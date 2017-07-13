defmodule SharedShopper.ShoppinglistController do
  use SharedShopper.Web, :controller
  plug :assign_user
  #plug :authorize_user when action in [:new, :create, :update, :edit, :delete]
  plug :set_authorization_flag

  alias SharedShopper.Shoppinglist

  def index(conn, _params) do
    shoppinglist = Repo.all(assoc(conn.assigns[:user], :shoppinglist))
    render(conn, "index.html", shoppinglist: shoppinglist)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:shoppinglist)
      |> Shoppinglist.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"shoppinglist" => shoppinglist_params}) do
    changeset =
     conn.assigns[:user]
     |> build_assoc(:shoppinglist)
     |> Shoppinglist.changeset(shoppinglist_params)

   case Repo.insert(changeset) do
     {:ok, _shoppinglist} ->
       conn
       |> put_flash(:info, "Shopping List created successfully.")
       |> redirect(to: user_shoppinglist_path(conn, :index, conn.assigns[:user]))
     {:error, changeset} ->
       render(conn, "new.html", changeset: changeset)
   end
  end

  def show(conn, %{"id" => id}) do
    shoppinglist = Repo.get!(assoc(conn.assigns[:user], :shoppinglist), id)
      |> Repo.preload(:todos)
    todo_changeset = shoppinglist
      |> build_assoc(:todos)
      |> SharedShopper.Todo.changeset()
    render(conn, "show.html", shoppinglist: shoppinglist, todo_changeset: todo_changeset)
  end

  def edit(conn, %{"id" => id}) do
    shoppinglist = Repo.get!(assoc(conn.assigns[:user], :shoppinglist), id)
    changeset = Shoppinglist.changeset(shoppinglist)
    render(conn, "edit.html", shoppinglist: shoppinglist, changeset: changeset)
  end

  def update(conn, %{"id" => id, "shoppinglist" => shoppinglist_params}) do
    shoppinglist = Repo.get!(assoc(conn.assigns[:user], :shoppinglist), id)
    changeset = Shoppinglist.changeset(shoppinglist, shoppinglist_params)

    case Repo.update(changeset) do
      {:ok, shoppinglist} ->
        conn
        |> put_flash(:info, "Shopping List updated successfully.")
        |> redirect(to: user_shoppinglist_path(conn, :show, conn.assigns[:user], shoppinglist))
      {:error, changeset} ->
        render(conn, "edit.html", shoppinglist: shoppinglist, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    shoppinglist = Repo.get!(assoc(conn.assigns[:user], :shoppinglist), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(shoppinglist)

    conn
    |> put_flash(:info, "Shopping list deleted successfully.")
    |> redirect(to: user_shoppinglist_path(conn, :index,  conn.assigns[:user]))
  end

  defp assign_user(conn, _opts) do
    case conn.params do
      %{"user_id" => user_id} ->
      case Repo.get(SharedShopper.User, user_id) do
          nil  -> invalid_user(conn)
          user -> assign(conn, :user, user)
        end
      _ -> invalid_user(conn)
      end
    end

    defp invalid_user(conn) do
      conn
      |> put_flash(:error, "Invalid user!")
      |> redirect(to: page_path(conn, :index))
      |> halt
    end


    defp authorize_user(conn, _opts) do
      if is_authorized_user?(conn) do
        conn
      else
        conn
        |> put_flash(:error, "You are not authorized to modify that post!")
        |> redirect(to: page_path(conn, :index))
        |> halt
      end
    end

    defp is_authorized_user?(conn) do
      user = get_session(conn, :current_user)
      (user && (Integer.to_string(user.id) == conn.params["user_id"] || SharedShopper.RoleChecker.is_admin?(user)))
    end

    defp set_authorization_flag(conn, _opts) do
      assign(conn, :author_or_admin, is_authorized_user?(conn))
    end

end
