defmodule ElxWeb.UrlTabControllerTest do
  use ElxWeb.ConnCase

  alias Elx.UrlApp
  alias Elx.UrlApp.UrlTab

  @create_attrs %{
    short_key: "some short_key",
    url: "some url"
  }
  @update_attrs %{
    short_key: "some updated short_key",
    url: "some updated url"
  }
  @invalid_attrs %{short_key: nil, url: nil}

  def fixture(:url_tab) do
    {:ok, url_tab} = UrlApp.create_url_tab(@create_attrs)
    url_tab
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all urls_tab", %{conn: conn} do
      conn = get(conn, Routes.url_tab_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create url_tab" do
    test "renders url_tab when data is valid", %{conn: conn} do
      conn = post(conn, Routes.url_tab_path(conn, :create), url_tab: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.url_tab_path(conn, :show, id))

      assert %{
               "id" => id,
               "short_key" => "some short_key",
               "url" => "some url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.url_tab_path(conn, :create), url_tab: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update url_tab" do
    setup [:create_url_tab]

    test "renders url_tab when data is valid", %{conn: conn, url_tab: %UrlTab{id: id} = url_tab} do
      conn = put(conn, Routes.url_tab_path(conn, :update, url_tab), url_tab: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.url_tab_path(conn, :show, id))

      assert %{
               "id" => id,
               "short_key" => "some updated short_key",
               "url" => "some updated url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, url_tab: url_tab} do
      conn = put(conn, Routes.url_tab_path(conn, :update, url_tab), url_tab: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete url_tab" do
    setup [:create_url_tab]

    test "deletes chosen url_tab", %{conn: conn, url_tab: url_tab} do
      conn = delete(conn, Routes.url_tab_path(conn, :delete, url_tab))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.url_tab_path(conn, :show, url_tab))
      end
    end
  end

  defp create_url_tab(_) do
    url_tab = fixture(:url_tab)
    {:ok, url_tab: url_tab}
  end
end
