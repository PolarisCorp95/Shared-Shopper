defmodule SharedShopper.ShoppingListController do
  use SharedShopper.Web, :controller
  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]
  alias SharedShopper.ShoppingList

  def index(conn, _params) do
    shoppinglist = Repo.all(assoc(conn.assigns[:user], :shoppinglist))
    render(conn, "index.html", shoppinglist: shoppinglist)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:shoppinglist)
      |> ShoppingList.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"shopping_list" => shopping_list_params}) do
    changeset =
     conn.assigns[:user]
     |> build_assoc(:shoppinglist)
     |> ShoppingList.changeset(shopping_list_params)

   case Repo.insert(changeset) do
     {:ok, _shopping_list} ->
       conn
       |> put_flash(:info, "Shopping List created successfully.")
       |> redirect(to: user_shopping_list_path(conn, :index, conn.assigns[:user]))
     {:error, changeset} ->
       render(conn, "new.html", changeset: changeset)
   end
  end

  def show(conn, %{"id" => id}) do
    shopping_list = Repo.get!(assoc(conn.assigns[:user], :shoppinglist), id)
    render(conn, "show.html", shopping_list: shopping_list)
  end

  def edit(conn, %{"id" => id}) do
    shopping_list = Repo.get!(assoc(conn.assigns[:user], :shoppinglist), id)
    changeset = ShoppingList.changeset(shopping_list)
    render(conn, "edit.html", shopping_list: shopping_list, changeset: changeset)
  end

  def update(conn, %{"id" => id, "shopping_list" => shopping_list_params}) do
    shopping_list = Repo.get!(assoc(conn.assigns[:user], :shoppinglist), id)
    changeset = ShoppingList.changeset(shopping_list, shopping_list_params)

    case Repo.update(changeset) do
      {:ok, shopping_list} ->
        conn
        |> put_flash(:info, "Shopping List updated successfully.")
        |> redirect(to: user_shopping_list_path(conn, :show, conn.assigns[:user], shopping_list))
      {:error, changeset} ->
        render(conn, "edit.html", shopping_list: shopping_list, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    shopping_list = Repo.get!(assoc(conn.assigns[:user], :shoppinglist), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(shopping_list)

    conn
    |> put_flash(:info, "Shopping list deleted successfully.")
    |> redirect(to: user_shopping_list_path(conn, :index,  conn.assigns[:user]))
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
        user = get_session(conn, :current_user)
          if user && (Integer.to_string(user.id) == conn.params["user_id"] || SharedShopper.RoleChecker.is_admin?(user)) do
          conn
        else
          conn
          |> put_flash(:error, "You are not authorized to modify that Shopping List!")
          |> redirect(to: page_path(conn, :index))
          |> halt()
        end
      end


end
