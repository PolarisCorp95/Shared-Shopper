defmodule SharedShopper.TodoController do
  use SharedShopper.Web, :controller
  alias SharedShopper.Todo
  alias SharedShopper.Shoppinglist
  plug :scrub_params, "todo" when action in [:create, :update]

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


    def update(conn, _), do: conn
  def delete(conn, _), do: conn




end
