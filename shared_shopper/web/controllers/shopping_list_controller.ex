defmodule SharedShopper.ShoppingListController do
  use SharedShopper.Web, :controller

  alias SharedShopper.ShoppingList

  def index(conn, _params) do
    shoppinglists = Repo.all(ShoppingList)
    render(conn, "index.html", shoppinglists: shoppinglists)
  end

  def new(conn, _params) do
    changeset = Guardian.Plug.current_resource(conn)
    |> build_assoc(:slists)
    |> ShoppingList.changeset()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"shopping_list" => shopping_list_params}) do
    changeset = Guardian.Plug.current_resource(conn)
    |> build_assoc(:slists)
    |> ShoppingList.changeset(shopping_list_params)

    case Repo.insert(changeset) do
      {:ok, _shopping_list_params} ->
        conn
        |> put_flash(:info, "Shopping List created successfully.")
        |> redirect(to: shopping_list_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

@doc """
  def new(conn, _params) do
    changeset = ShoppingList.changeset(%ShoppingList{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"shopping_list" => shopping_list_params}) do
    changeset = ShoppingList.changeset(%ShoppingList{}, shopping_list_params)

    case Repo.insert(changeset) do
      {:ok, _shopping_list} ->
        conn
        |> put_flash(:info, "Shopping list created successfully.")
        |> redirect(to: shopping_list_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
"""
  def show(conn, %{"id" => id}) do
    shopping_list = Repo.get!(ShoppingList, id)
    render(conn, "show.html", shopping_list: shopping_list)
  end

  def edit(conn, %{"id" => id}) do
    shopping_list = Repo.get!(ShoppingList, id)
    changeset = ShoppingList.changeset(shopping_list)
    render(conn, "edit.html", shopping_list: shopping_list, changeset: changeset)
  end

  def update(conn, %{"id" => id, "shopping_list" => shopping_list_params}) do
    shopping_list = Repo.get!(ShoppingList, id)
    changeset = ShoppingList.changeset(shopping_list, shopping_list_params)

    case Repo.update(changeset) do
      {:ok, shopping_list} ->
        conn
        |> put_flash(:info, "Shopping list updated successfully.")
        |> redirect(to: shopping_list_path(conn, :show, shopping_list))
      {:error, changeset} ->
        render(conn, "edit.html", shopping_list: shopping_list, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    shopping_list = Repo.get!(ShoppingList, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(shopping_list)

    conn
    |> put_flash(:info, "Shopping list deleted successfully.")
    |> redirect(to: shopping_list_path(conn, :index))
  end
end
