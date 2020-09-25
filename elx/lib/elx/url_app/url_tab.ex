defmodule Elx.UrlApp.UrlTab do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls_tab" do
    field :ctime, :integer
    field :hashed_url, :binary
    field :short_key, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(url_tab, attrs) do
    url_tab
    |> cast(attrs, [:url, :short_key, :hashed_url, :ctime])
    |> validate_required([:url, :short_key, :hashed_url, :ctime])
  end
end
