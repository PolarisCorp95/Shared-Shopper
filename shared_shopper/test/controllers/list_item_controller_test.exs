defmodule SharedShopper.ListItemControllerTest do
  use SharedShopper.ConnCase

  alias SharedShopper.ListItem
  @valid_attrs %{completed: true, description: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, list_item_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing listitems"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, list_item_path(conn, :new)
    assert html_response(conn, 200) =~ "New list item"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, list_item_path(conn, :create), list_item: @valid_attrs
    assert redirected_to(conn) == list_item_path(conn, :index)
    assert Repo.get_by(ListItem, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, list_item_path(conn, :create), list_item: @invalid_attrs
    assert html_response(conn, 200) =~ "New list item"
  end

  test "shows chosen resource", %{conn: conn} do
    list_item = Repo.insert! %ListItem{}
    conn = get conn, list_item_path(conn, :show, list_item)
    assert html_response(conn, 200) =~ "Show list item"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, list_item_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    list_item = Repo.insert! %ListItem{}
    conn = get conn, list_item_path(conn, :edit, list_item)
    assert html_response(conn, 200) =~ "Edit list item"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    list_item = Repo.insert! %ListItem{}
    conn = put conn, list_item_path(conn, :update, list_item), list_item: @valid_attrs
    assert redirected_to(conn) == list_item_path(conn, :show, list_item)
    assert Repo.get_by(ListItem, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    list_item = Repo.insert! %ListItem{}
    conn = put conn, list_item_path(conn, :update, list_item), list_item: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit list item"
  end

  test "deletes chosen resource", %{conn: conn} do
    list_item = Repo.insert! %ListItem{}
    conn = delete conn, list_item_path(conn, :delete, list_item)
    assert redirected_to(conn) == list_item_path(conn, :index)
    refute Repo.get(ListItem, list_item.id)
  end
end
