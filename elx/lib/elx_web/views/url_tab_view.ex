defmodule ElxWeb.UrlTabView do
  use ElxWeb, :view
  alias ElxWeb.UrlTabView

  def render("index.json", %{urls_tab: urls_tab}) do
    %{data: render_many(urls_tab, UrlTabView, "url_tab.json")}
  end

  def render("show.json", %{url: url}) do
    %{url: url.url}
  end

  def render("show.json", %{short_url: short_key, host: host}) do
    %{short_url: "#{host}/#{short_key}"}
  end

  def render("url_tab.json", %{url_tab: url_tab}) do
    %{id: url_tab.id, url: url_tab.url, short_key: url_tab.short_key}
  end
end
