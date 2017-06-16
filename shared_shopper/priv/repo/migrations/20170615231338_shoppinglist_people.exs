defmodule SharedShopper.Repo.Migrations.ShoppinglistPeople do
  use Ecto.Migration


    def change do
      alter table(:shoppinglist) do
        add :people, :map
      end
    end
  end
