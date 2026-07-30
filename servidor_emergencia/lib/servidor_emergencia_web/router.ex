defmodule ServidorEmergenciaWeb.Router do
  use ServidorEmergenciaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ServidorEmergenciaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ServidorEmergenciaWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/documentos", DocumentoController, :index

    live "/chat", ChatLive
    live "/rede", RedeLive

    live "/avisos", AvisoLive.Index, :index
    live "/avisos/new", AvisoLive.Form, :new
    live "/avisos/:id", AvisoLive.Show, :show
    live "/avisos/:id/edit", AvisoLive.Form, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", ServidorEmergenciaWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:servidor_emergencia, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ServidorEmergenciaWeb.Telemetry
    end
  end

  # Captive portal catch-all: qualquer rota não reconhecida (os testes de
  # conectividade que iOS/Android/Windows disparam ao entrar num Wi-Fi novo,
  # como /generate_204, /hotspot-detect.html, /ncsi.txt) cai aqui e é
  # redirecionada para a home. Precisa ser a ÚLTIMA rota do arquivo para não
  # sombrear nenhuma rota específica (inclusive o /dev/dashboard acima).
  #
  # Isso resolve só a parte HTTP do captive portal. Para o pop-up do captive
  # portal disparar de verdade no celular, falta o componente de DNS wildcard
  # (todo domínio resolvendo para o IP do Pi) — isso é feito na Fase 3, no
  # firmware Nerves, e não dá para testar sem o hardware real.
  scope "/", ServidorEmergenciaWeb do
    pipe_through :browser

    get "/*path", PageController, :captive_portal
  end
end
