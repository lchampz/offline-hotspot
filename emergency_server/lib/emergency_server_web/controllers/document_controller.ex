defmodule EmergencyServerWeb.DocumentController do
  use EmergencyServerWeb, :controller

  def index(conn, _params) do
    render(conn, :index, documents: list_documents())
  end

  defp list_documents do
    :emergency_server
    |> Application.app_dir("priv/static/documents")
    |> File.ls()
    |> case do
      {:ok, files} -> files
      {:error, _reason} -> []
    end
    |> Enum.filter(&String.ends_with?(&1, ".pdf"))
    |> Enum.sort()
  end
end
