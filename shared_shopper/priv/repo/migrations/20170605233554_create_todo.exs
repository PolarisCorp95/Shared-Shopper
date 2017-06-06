defmodule SharedShopper.Repo.Migrations.CreateTodo do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :title, :string
      add :description, :text
      add :completed, :boolean, default: false, null: false
      add :completedby, :string
      add :shoppinglist_id, references(:shoppinglist, on_delete: :nothing)

      timestamps()
    end
    create index(:todos, [:shoppinglist_id])

  end
end
