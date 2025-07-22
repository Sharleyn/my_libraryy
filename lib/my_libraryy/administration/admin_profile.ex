defmodule MyLibraryy.Administration.AdminProfile do
  use Ecto.Schema
  import Ecto.Changeset


  alias MyLibraryy.Administration.AdminProfile

  schema "admin_profiles" do
    field :status, :string
    field :address, :string
    field :full_name, :string
    field :ic, :string
    field :phone, :string
    field :date_of_birth, :date

    belongs_to :admin, AdminProfile

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(admin_profile, attrs) do
    admin_profile
    |> cast(attrs, [:full_name, :ic, :status, :phone, :address, :date_of_birth, :admin_id])
    |> validate_required([:full_name, :ic, :status, :phone, :address, :date_of_birth, :admin_id])
  end
end
