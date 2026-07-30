defmodule EmergencyServerWeb.Router do
  use EmergencyServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {EmergencyServerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EmergencyServerWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/documents", DocumentController, :index

    live "/chat", ChatLive
    live "/network", NetworkLive

    live "/notices", NoticeLive.Index, :index
    live "/notices/new", NoticeLive.Form, :new
    live "/notices/:id", NoticeLive.Show, :show
    live "/notices/:id/edit", NoticeLive.Form, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", EmergencyServerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:emergency_server, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EmergencyServerWeb.Telemetry
    end
  end

  # Captive portal catch-all: any unrecognized route (the connectivity
  # checks that iOS/Android/Windows fire when joining a new Wi-Fi network,
  # like /generate_204, /hotspot-detect.html, /ncsi.txt) lands here and
  # gets redirected to the home page. This MUST be the last route in the
  # file so it doesn't shadow any specific route (including /dev/dashboard
  # above).
  #
  # This only solves the HTTP half of the captive portal. For the pop-up
  # to actually fire on the phone, we still need the wildcard DNS piece
  # (every domain resolving to the Pi's IP) — that's done in Phase 3, in
  # the Nerves firmware, and can't be tested without real hardware.
  scope "/", EmergencyServerWeb do
    pipe_through :browser

    get "/*path", PageController, :captive_portal
  end
end
