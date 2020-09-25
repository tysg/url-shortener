defmodule ElxWeb.Router do
  use ElxWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ElxWeb do
    pipe_through(:api)

    resources("/", UrlTabController, only: [:show])
    post("/urls", UrlTabController, :create)
  end
end
