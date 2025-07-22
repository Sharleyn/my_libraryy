defmodule MyLibraryy.Repo.Migrations.AddReferencesToLoans do
  use Ecto.Migration

  def change do
    alter table(:loans) do
      add :user_id, references(:users, on_delete: :nothing)
      add :book_id, references(:books, on_delete: :nothing)
    end

    create index(:loans, [:user_id])
    create index(:loans, [:book_id])
  end
end
