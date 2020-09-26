defmodule ElxWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ElxWeb, :controller

  def call(conn, {:error, _}) do
    conn
    |> put_status(:not_found)
    |> put_view(ElxWeb.ErrorView)
    |> render(:"404")
  end
end
