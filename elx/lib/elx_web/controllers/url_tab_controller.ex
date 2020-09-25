defmodule ElxWeb.UrlTabController do
  use ElxWeb, :controller

  alias Elx.UrlApp
  alias Elx.UrlApp.UrlTab

  action_fallback(ElxWeb.FallbackController)

  def create(conn, %{"url_tab" => url_tab_params}) do
    with {:ok, %UrlTab{} = url_tab} <- UrlApp.create_url_tab(url_tab_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.url_tab_path(conn, :show, url_tab))
      |> render("show.json", url_tab: url_tab)
    end
  end

  def show(conn, %{"id" => short_key}) do
    url_tab = UrlApp.get_last_by_short_key(short_key)

    case url_tab do
      nil -> conn |> put_status(:not_found) |> put_view(ElxWeb.ErrorView) |> render(:"404")
      tabs -> render(conn, "show.json", url: tabs)
    end
  end
end
