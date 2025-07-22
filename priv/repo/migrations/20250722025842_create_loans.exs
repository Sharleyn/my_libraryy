defmodule MyLibraryy.Repo.Migrations.CreateLoans do
  use Ecto.Migration

  def change do
    create table(:loans) do
      add :borrowed_at, :date
      add :due_at, :date
      add :returned_at, :date

      timestamps(type: :utc_datetime)
    end
  end
end
