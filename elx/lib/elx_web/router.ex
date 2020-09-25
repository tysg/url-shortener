defmodule ElxWeb.Router do
  use ElxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ElxWeb do
    pipe_through :api
  end
end
