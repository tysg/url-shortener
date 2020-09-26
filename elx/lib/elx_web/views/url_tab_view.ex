defmodule ElxWeb.UrlTabView do
  use ElxWeb, :view
  alias ElxWeb.UrlTabView

  def render("show.json", %{url: url}) do
    %{url: url}
  end

  def render("show.json", %{short_url: short_key, host: host}) do
    %{short_url: "#{host}/#{short_key}"}
  end
end
