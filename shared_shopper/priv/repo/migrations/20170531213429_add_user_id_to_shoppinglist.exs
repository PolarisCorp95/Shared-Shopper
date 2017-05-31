defmodule SharedShopper.Repo.Migrations.AddUserIdToShoppinglist do
 use Ecto.Migration

 def change do
   alter table(:shoppinglist) do
     add :user_id, references(:users)
 end
   create index(:shoppinglist, [:user_id])
 end
end
