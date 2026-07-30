defmodule ServidorEmergencia.AvisosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ServidorEmergencia.Avisos` context.
  """

  @doc """
  Generate a aviso.
  """
  def aviso_fixture(attrs \\ %{}) do
    {:ok, aviso} =
      attrs
      |> Enum.into(%{
        autor: "some autor",
        categoria: "recado",
        conteudo: "some conteudo",
        titulo: "some titulo"
      })
      |> ServidorEmergencia.Avisos.create_aviso()

    aviso
  end
end
