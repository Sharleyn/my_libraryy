defmodule MyLibraryy.Library.Loan do
  use Ecto.Schema
  import Ecto.Changeset


  schema "loans" do
    field :borrowed_at, :date
    field :due_at, :date
    field :returned_at, :date


    belongs_to :user, MyLibraryy.Accounts.User
    belongs_to :book, MyLibraryy.Library.Book

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(loan, attrs) do
    loan
    |> cast(attrs, [:user_id, :book_id, :borrowed_at, :due_at, :returned_at])
    |> validate_required([:user_id, :book_id, :borrowed_at, :due_at, :returned_at])
    |> cast_assoc(:user)
    |> cast_assoc(:book)
  end
end
