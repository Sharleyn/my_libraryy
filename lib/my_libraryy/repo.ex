defmodule MyLibraryy.Repo do
  use Ecto.Repo,
    otp_app: :my_libraryy,
    adapter: Ecto.Adapters.Postgres
end
