defmodule SharedShopper.Router do
  use SharedShopper.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SharedShopper.CurrentUserPlug
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.EnsureAuthenticated, handler: Todo.Token
    plug Guardian.Plug.LoadResource
  end




  scope "/", SharedShopper do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController do
      resources "/shoppinglist", ShoppinglistController
    end
    resources "/shoppinglist", ShoppinglistController, only: [] do
        resources "/todos", TodoController, only: [:create, :delete, :update]
    end
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SharedShopper do
  #   pipe_through :api
  # end
end
