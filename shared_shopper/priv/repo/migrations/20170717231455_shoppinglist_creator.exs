defmodule SharedShopper.Repo.Migrations.ShoppinglistCreator do
  use Ecto.Migration

  def change do
    alter table(:shoppinglist) do
      add :creator, :string
    end
  end
end
