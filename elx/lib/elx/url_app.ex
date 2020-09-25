defmodule Elx.UrlApp do
  @moduledoc """
  The UrlApp context.
  """

  import Ecto.Query, warn: false
  alias Elx.Repo

  alias Elx.UrlApp.UrlTab
  alias Elx.Util

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
end
