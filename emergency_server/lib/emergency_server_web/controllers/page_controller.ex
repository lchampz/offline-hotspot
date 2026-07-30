defmodule EmergencyServerWeb.PageController do
  use EmergencyServerWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  @doc """
  Catches any unrecognized route (hit by the phone OS's captive portal
  connectivity checks) and redirects to the home page.
  """
  def captive_portal(conn, _params) do
    redirect(conn, to: ~p"/")
  end
end
