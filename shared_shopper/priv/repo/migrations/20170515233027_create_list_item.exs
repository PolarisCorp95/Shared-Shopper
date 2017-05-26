defmodule SharedShopper.Repo.Migrations.CreateListItem do
  use Ecto.Migration

  def change do
    create table(:listitems) do
      add :title, :string
      add :description, :string
      add :completed, :boolean, default: false, null: false
      add :shoppinglist_id, references(:shoppinglists, on_delete: :nothing)

      timestamps()
    end
    create index(:listitems, [:shoppinglist_id])

  end
end
