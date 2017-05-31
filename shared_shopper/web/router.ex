defmodule SharedShopper.Router do
  use SharedShopper.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SharedShopper do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/shoppinglist", ShoppingListController
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SharedShopper do
  #   pipe_through :api
  # end
end
