# based on Nat Tuck's Lecture Notes and Example Code
# See:
# https://github.com/NatTuck/scratch-2021-01/blob/master/notes-4550/11-photoblog/notes.md
# https://github.com/NatTuck/scratch-2021-01/blob/master/4550/0223/photo_blog/lib/photo_blog_web/router.ex
defmodule EventAppWeb.Router do
  use EventAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug EventAppWeb.Plugs.FetchUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EventAppWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/events", EventController do
      get "/invitee", EventController, :invitee, as: :invitee
    end
    resources "/users", UserController
    resources "/comments", CommentController
    resources "/invites", InviteController
    resources "/sessions", SessionController,
      only: [:create, :delete], singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", EventAppWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: EventAppWeb.Telemetry
    end
  end
end
