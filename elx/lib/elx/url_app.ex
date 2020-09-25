defmodule Elx.UrlApp do
  @moduledoc """
  The UrlApp context.
  """

  import Ecto.Query, warn: false
  alias Elx.Repo

  alias Elx.UrlApp.UrlTab
  alias Elx.Util

  @doc """
  Returns the list of urls_tab.

  ## Examples

      iex> list_urls_tab()
      [%UrlTab{}, ...]

  """
  def list_urls_tab do
    Repo.all(UrlTab)
  end

  @doc """
  Gets a single url_tab.

  Raises `Ecto.NoResultsError` if the Url tab does not exist.

  ## Examples

      iex> get_url_tab!(123)
      %UrlTab{}

      iex> get_url_tab!(456)
      ** (Ecto.NoResultsError)

  """

  # def get_url_tab!(id) do
  #   query = from (u in UrlTab, where: u.short_key == )
  #   Repo.get!(UrlTab, id)
  # end

  def get_last_by_short_key(short_key) do
    case Elx.Bucket.get(short_key) do
      nil ->
        query =
          first(from(u in UrlTab, where: u.short_key == ^short_key, order_by: [desc: u.ctime]))

        case Repo.one(query) do
          nil ->
            nil

          url_tab ->
            Elx.Bucket.put(short_key, url_tab.url)
            url_tab.url
        end

      val ->
        val
    end
  end

  def find_match_by_url(url) do
    hash = Util.hash_url(url)
    query = first(from(u in UrlTab, where: u.hashed_url == ^hash, order_by: [desc: u.ctime]))
    Repo.one(query)
  end

  @doc """
  Creates a url_tab.

  ## Examples

      iex> create_url_tab(%{field: value})
      {:ok, %UrlTab{}}

      iex> create_url_tab(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_url_tab(url \\ %{}) do
    case find_match_by_url(url) do
      nil ->
        short_key = Elx.Counter.generate()
        hash = Elx.Util.hash_url(url)
        timestamp = :os.system_time(:seconds)

        res =
          %UrlTab{}
          |> UrlTab.changeset(%{
            short_key: short_key,
            url: url,
            hashed_url: hash,
            ctime: timestamp
          })
          |> Repo.insert()

        case res do
          {:ok, result} ->
            Elx.Bucket.put(result.short_key, result.url)
        end

        res

      result ->
        {:ok, result}
    end
  end

  @doc """
  Updates a url_tab.

  ## Examples

      iex> update_url_tab(url_tab, %{field: new_value})
      {:ok, %UrlTab{}}

      iex> update_url_tab(url_tab, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_url_tab(%UrlTab{} = url_tab, attrs) do
    url_tab
    |> UrlTab.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a url_tab.

  ## Examples

      iex> delete_url_tab(url_tab)
      {:ok, %UrlTab{}}

      iex> delete_url_tab(url_tab)
      {:error, %Ecto.Changeset{}}

  """
  def delete_url_tab(%UrlTab{} = url_tab) do
    Repo.delete(url_tab)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking url_tab changes.

  ## Examples

      iex> change_url_tab(url_tab)
      %Ecto.Changeset{source: %UrlTab{}}

  """
  def change_url_tab(%UrlTab{} = url_tab) do
    UrlTab.changeset(url_tab, %{})
  end
end
