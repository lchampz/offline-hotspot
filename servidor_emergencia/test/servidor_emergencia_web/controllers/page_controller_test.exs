defmodule ServidorEmergenciaWeb.PageControllerTest do
  use ServidorEmergenciaWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Rede de Emergência"
  end
end
