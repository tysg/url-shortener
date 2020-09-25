defmodule Elx.UrlAppTest do
  use Elx.DataCase

  alias Elx.UrlApp

  describe "urls_tab" do
    alias Elx.UrlApp.UrlTab

    @valid_attrs %{ctime: 42, hashed_url: "some hashed_url", short_key: "some short_key", url: "some url"}
    @update_attrs %{ctime: 43, hashed_url: "some updated hashed_url", short_key: "some updated short_key", url: "some updated url"}
    @invalid_attrs %{ctime: nil, hashed_url: nil, short_key: nil, url: nil}

    def url_tab_fixture(attrs \\ %{}) do
      {:ok, url_tab} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UrlApp.create_url_tab()

      url_tab
    end

    test "list_urls_tab/0 returns all urls_tab" do
      url_tab = url_tab_fixture()
      assert UrlApp.list_urls_tab() == [url_tab]
    end

    test "get_url_tab!/1 returns the url_tab with given id" do
      url_tab = url_tab_fixture()
      assert UrlApp.get_url_tab!(url_tab.id) == url_tab
    end

    test "create_url_tab/1 with valid data creates a url_tab" do
      assert {:ok, %UrlTab{} = url_tab} = UrlApp.create_url_tab(@valid_attrs)
      assert url_tab.ctime == 42
      assert url_tab.hashed_url == "some hashed_url"
      assert url_tab.short_key == "some short_key"
      assert url_tab.url == "some url"
    end

    test "create_url_tab/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UrlApp.create_url_tab(@invalid_attrs)
    end

    test "update_url_tab/2 with valid data updates the url_tab" do
      url_tab = url_tab_fixture()
      assert {:ok, %UrlTab{} = url_tab} = UrlApp.update_url_tab(url_tab, @update_attrs)
      assert url_tab.ctime == 43
      assert url_tab.hashed_url == "some updated hashed_url"
      assert url_tab.short_key == "some updated short_key"
      assert url_tab.url == "some updated url"
    end

    test "update_url_tab/2 with invalid data returns error changeset" do
      url_tab = url_tab_fixture()
      assert {:error, %Ecto.Changeset{}} = UrlApp.update_url_tab(url_tab, @invalid_attrs)
      assert url_tab == UrlApp.get_url_tab!(url_tab.id)
    end

    test "delete_url_tab/1 deletes the url_tab" do
      url_tab = url_tab_fixture()
      assert {:ok, %UrlTab{}} = UrlApp.delete_url_tab(url_tab)
      assert_raise Ecto.NoResultsError, fn -> UrlApp.get_url_tab!(url_tab.id) end
    end

    test "change_url_tab/1 returns a url_tab changeset" do
      url_tab = url_tab_fixture()
      assert %Ecto.Changeset{} = UrlApp.change_url_tab(url_tab)
    end
  end
end
