defmodule SharedShopper.ListItemController do
  use SharedShopper.Web, :controller

  alias SharedShopper.ListItem

  def index(conn, _params) do
    listitems = Repo.all(ListItem)
    render(conn, "index.html", listitems: listitems)
  end

  def new(conn, _params) do
    changeset = ListItem.changeset(%ListItem{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"list_item" => list_item_params}) do
    changeset = ListItem.changeset(%ListItem{}, list_item_params)

    case Repo.insert(changeset) do
      {:ok, _list_item} ->
        conn
        |> put_flash(:info, "List item created successfully.")
        |> redirect(to: list_item_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    list_item = Repo.get!(ListItem, id)
    render(conn, "show.html", list_item: list_item)
  end

  def edit(conn, %{"id" => id}) do
    list_item = Repo.get!(ListItem, id)
    changeset = ListItem.changeset(list_item)
    render(conn, "edit.html", list_item: list_item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "list_item" => list_item_params}) do
    list_item = Repo.get!(ListItem, id)
    changeset = ListItem.changeset(list_item, list_item_params)

    case Repo.update(changeset) do
      {:ok, list_item} ->
        conn
        |> put_flash(:info, "List item updated successfully.")
        |> redirect(to: list_item_path(conn, :show, list_item))
      {:error, changeset} ->
        render(conn, "edit.html", list_item: list_item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    list_item = Repo.get!(ListItem, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(list_item)

    conn
    |> put_flash(:info, "List item deleted successfully.")
    |> redirect(to: list_item_path(conn, :index))
  end
end
