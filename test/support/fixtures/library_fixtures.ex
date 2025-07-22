defmodule MyLibraryy.LibraryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MyLibraryy.Library` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        author: "some author",
        isbn: "some isbn",
        published_at: ~D[2025-07-21],
        title: "some title"
      })
      |> MyLibraryy.Library.create_book()

    book
  end

  @doc """
  Generate a loan.
  """
  def loan_fixture(attrs \\ %{}) do
    {:ok, loan} =
      attrs
      |> Enum.into(%{
        borrowed_at: ~D[2025-07-21],
        due_at: ~D[2025-07-21],
        returned_at: ~D[2025-07-21]
      })
      |> MyLibraryy.Library.create_loan()

    loan
  end
end
