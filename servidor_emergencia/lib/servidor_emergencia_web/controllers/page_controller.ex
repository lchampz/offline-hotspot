defmodule ServidorEmergenciaWeb.PageController do
  use ServidorEmergenciaWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  @doc """
  Recebe qualquer rota desconhecida (usada pelos testes de captive portal do
  SO do celular) e redireciona para a home.
  """
  def captive_portal(conn, _params) do
    redirect(conn, to: ~p"/")
  end
end
