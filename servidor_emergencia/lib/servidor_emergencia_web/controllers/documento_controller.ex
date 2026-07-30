defmodule ServidorEmergenciaWeb.DocumentoController do
  use ServidorEmergenciaWeb, :controller

  def index(conn, _params) do
    render(conn, :index, documentos: list_documentos())
  end

  defp list_documentos do
    :servidor_emergencia
    |> Application.app_dir("priv/static/documentos")
    |> File.ls()
    |> case do
      {:ok, files} -> files
      {:error, _reason} -> []
    end
    |> Enum.filter(&String.ends_with?(&1, ".pdf"))
    |> Enum.sort()
  end
end
