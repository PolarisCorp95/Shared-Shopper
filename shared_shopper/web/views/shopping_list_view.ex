defmodule SharedShopper.ShoppinglistView do
  use SharedShopper.Web, :view
  def connection_keys(conn) do
    "Test"
  end
end
