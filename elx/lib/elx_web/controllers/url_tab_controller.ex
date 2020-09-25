defmodule ElxWeb.UrlTabController do
  use ElxWeb, :controller

  alias Elx.UrlApp
  alias Elx.UrlApp.UrlTab

  action_fallback(ElxWeb.FallbackController)

  defp validate_uri(str) do
    uri = URI.parse(str)

    case uri do
      %URI{scheme: nil} -> {:error, uri}
      %URI{host: nil} -> {:error, uri}
      %URI{path: nil} -> {:error, uri}
      uri -> {:ok, str}
    end
  end

  def create(conn, %{"url" => input_url}) do
    with {:ok, url} <- validate_uri(input_url) do
      with {:ok, %UrlTab{} = url_tab} <- UrlApp.create_url_tab(url) do
        conn
        |> put_status(:ok)
        |> put_resp_header("location", Routes.url_tab_path(conn, :show, url_tab))
        # HACK: hard coding value
        |> render("show.json", %{short_url: url_tab.short_key, host: "http://localhost:8080"})
      end
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
