defmodule SharedShopper.ShoppingListControllerTest do
  use SharedShopper.ConnCase

  alias SharedShopper.ShoppingList
  @valid_attrs %{completed: true, description: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, shopping_list_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing shoppinglist"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, shopping_list_path(conn, :new)
    assert html_response(conn, 200) =~ "New shopping list"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, shopping_list_path(conn, :create), shopping_list: @valid_attrs
    assert redirected_to(conn) == shopping_list_path(conn, :index)
    assert Repo.get_by(ShoppingList, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, shopping_list_path(conn, :create), shopping_list: @invalid_attrs
    assert html_response(conn, 200) =~ "New shopping list"
  end

  test "shows chosen resource", %{conn: conn} do
    shopping_list = Repo.insert! %ShoppingList{}
    conn = get conn, shopping_list_path(conn, :show, shopping_list)
    assert html_response(conn, 200) =~ "Show shopping list"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, shopping_list_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    shopping_list = Repo.insert! %ShoppingList{}
    conn = get conn, shopping_list_path(conn, :edit, shopping_list)
    assert html_response(conn, 200) =~ "Edit shopping list"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    shopping_list = Repo.insert! %ShoppingList{}
    conn = put conn, shopping_list_path(conn, :update, shopping_list), shopping_list: @valid_attrs
    assert redirected_to(conn) == shopping_list_path(conn, :show, shopping_list)
    assert Repo.get_by(ShoppingList, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    shopping_list = Repo.insert! %ShoppingList{}
    conn = put conn, shopping_list_path(conn, :update, shopping_list), shopping_list: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit shopping list"
  end

  test "deletes chosen resource", %{conn: conn} do
    shopping_list = Repo.insert! %ShoppingList{}
    conn = delete conn, shopping_list_path(conn, :delete, shopping_list)
    assert redirected_to(conn) == shopping_list_path(conn, :index)
    refute Repo.get(ShoppingList, shopping_list.id)
  end
end
