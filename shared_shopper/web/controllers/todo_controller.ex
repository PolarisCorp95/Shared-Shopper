defmodule SharedShopper.TodoController do
  use SharedShopper.Web, :controller
  alias SharedShopper.Todo
  alias SharedShopper.ShoppingList
  plug :scrub_params, "todo" when action in [:create, :update]

  def create(conn, %{"todo" => todo_params, "shoppinglist_id" => shoppinglist_id}) do
    shoppinglist = Repo.get!(ShoppingList, shoppinglist_id) |> Repo.preload([:user, :todos])
    changeset = shoppinglist
      |> build_assoc(:todos)
      |> Todo.changeset(todo_params)

    case Repo.insert(changeset) do
      {:ok, _todo} ->
        conn
        |> put_flash(:info, "Todo created successfully!")
        |> redirect(to: user_shopping_list_path(conn, :show, shoppinglist.user, shoppinglist))
      {:error, changeset} ->
        render(conn, SharedShopper.ShoppingListView, "show.html", shoppinglist: shoppinglist, user: shoppinglist.user, todo_changeset: changeset)
    end
  end


    def update(conn, _), do: conn
  def delete(conn, _), do: conn




end
