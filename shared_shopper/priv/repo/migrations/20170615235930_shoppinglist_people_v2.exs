defmodule SharedShopper.Repo.Migrations.ShoppinglistPeopleV2 do
  use Ecto.Migration

  def change do
    alter table(:shoppinglist) do
      add :people, :map
    end
  end
end
