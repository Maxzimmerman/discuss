defmodule DiscussWeb.Router do
  use DiscussWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DiscussWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Discuss.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DiscussWeb do
    pipe_through :browser

    get "/", TopicController, :index
    get "/topics/new", TopicController, :new
    post "/topics", TopicController, :create
    get "/topics/:id/edit", TopicController, :edit
    put "/topics/:id/update", TopicController, :update
    delete "/topics/:id/delete", TopicController, :delete
    get "/:id/show", TopicController, :show
  end

  scope "/auth", DiscussWeb do
    pipe_through :browser

    get "/login", AuthController, :login
    post "/log-user-in", AuthController, :log_user_in
    get "/signup", AuthController, :signup
    post "/create_user", AuthController, :create_user
    get "/signout", AuthController, :signout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end


  # Other scopes may use custom stacks.
  # scope "/api", DiscussWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:discuss, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DiscussWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
