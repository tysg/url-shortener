defmodule Elx.Repo.Migrations.CreateUrlsTab do
  use Ecto.Migration

  def change do
    create table(:urls_tab) do
      add(:url, :string)
      add(:short_key, :string)
      add(:hashed_url, :binary)
      add(:ctime, :integer)

      # timestamps()
    end
  end
end
