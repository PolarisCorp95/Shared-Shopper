defmodule SharedShopper.Repo.Migrations.CreateShoppingList do
  use Ecto.Migration

  def change do
    create table(:shoppinglists) do
      add :title, :string
      add :description, :string
      add :completed, :boolean, default: false, null: false
      add :list_items, {:array, :string}
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:shoppinglists, [:user_id])

  end
end
