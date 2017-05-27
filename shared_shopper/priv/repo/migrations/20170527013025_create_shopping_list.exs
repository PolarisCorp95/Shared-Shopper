defmodule SharedShopper.Repo.Migrations.CreateShoppingList do
  use Ecto.Migration

  def change do
    create table(:shoppinglist) do
      add :title, :string
      add :description, :string
      add :completed, :boolean, default: false, null: false

      timestamps()
    end

  end
end
