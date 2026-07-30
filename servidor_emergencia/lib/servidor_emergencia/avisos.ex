defmodule ServidorEmergencia.Avisos do
  @moduledoc """
  The Avisos context.
  """

  import Ecto.Query, warn: false
  alias ServidorEmergencia.Repo

  alias ServidorEmergencia.Avisos.Aviso

  @doc """
  Returns the list of avisos.

  ## Examples

      iex> list_avisos()
      [%Aviso{}, ...]

  """
  def list_avisos do
    Repo.all(Aviso)
  end

  @doc """
  Gets a single aviso.

  Raises `Ecto.NoResultsError` if the Aviso does not exist.

  ## Examples

      iex> get_aviso!(123)
      %Aviso{}

      iex> get_aviso!(456)
      ** (Ecto.NoResultsError)

  """
  def get_aviso!(id), do: Repo.get!(Aviso, id)

  @doc """
  Creates a aviso.

  ## Examples

      iex> create_aviso(%{field: value})
      {:ok, %Aviso{}}

      iex> create_aviso(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_aviso(attrs) do
    %Aviso{}
    |> Aviso.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a aviso.

  ## Examples

      iex> update_aviso(aviso, %{field: new_value})
      {:ok, %Aviso{}}

      iex> update_aviso(aviso, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_aviso(%Aviso{} = aviso, attrs) do
    aviso
    |> Aviso.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a aviso.

  ## Examples

      iex> delete_aviso(aviso)
      {:ok, %Aviso{}}

      iex> delete_aviso(aviso)
      {:error, %Ecto.Changeset{}}

  """
  def delete_aviso(%Aviso{} = aviso) do
    Repo.delete(aviso)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking aviso changes.

  ## Examples

      iex> change_aviso(aviso)
      %Ecto.Changeset{data: %Aviso{}}

  """
  def change_aviso(%Aviso{} = aviso, attrs \\ %{}) do
    Aviso.changeset(aviso, attrs)
  end
end
