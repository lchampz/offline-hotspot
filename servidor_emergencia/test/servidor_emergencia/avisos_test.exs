defmodule ServidorEmergencia.AvisosTest do
  use ServidorEmergencia.DataCase

  alias ServidorEmergencia.Avisos

  describe "avisos" do
    alias ServidorEmergencia.Avisos.Aviso

    import ServidorEmergencia.AvisosFixtures

    @invalid_attrs %{titulo: nil, categoria: nil, autor: nil, conteudo: nil}

    test "list_avisos/0 returns all avisos" do
      aviso = aviso_fixture()
      assert Avisos.list_avisos() == [aviso]
    end

    test "get_aviso!/1 returns the aviso with given id" do
      aviso = aviso_fixture()
      assert Avisos.get_aviso!(aviso.id) == aviso
    end

    test "create_aviso/1 with valid data creates a aviso" do
      valid_attrs = %{titulo: "some titulo", categoria: "recado", autor: "some autor", conteudo: "some conteudo"}

      assert {:ok, %Aviso{} = aviso} = Avisos.create_aviso(valid_attrs)
      assert aviso.titulo == "some titulo"
      assert aviso.categoria == "recado"
      assert aviso.autor == "some autor"
      assert aviso.conteudo == "some conteudo"
    end

    test "create_aviso/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Avisos.create_aviso(@invalid_attrs)
    end

    test "update_aviso/2 with valid data updates the aviso" do
      aviso = aviso_fixture()
      update_attrs = %{titulo: "some updated titulo", categoria: "pedido_ajuda", autor: "some updated autor", conteudo: "some updated conteudo"}

      assert {:ok, %Aviso{} = aviso} = Avisos.update_aviso(aviso, update_attrs)
      assert aviso.titulo == "some updated titulo"
      assert aviso.categoria == "pedido_ajuda"
      assert aviso.autor == "some updated autor"
      assert aviso.conteudo == "some updated conteudo"
    end

    test "update_aviso/2 with invalid data returns error changeset" do
      aviso = aviso_fixture()
      assert {:error, %Ecto.Changeset{}} = Avisos.update_aviso(aviso, @invalid_attrs)
      assert aviso == Avisos.get_aviso!(aviso.id)
    end

    test "delete_aviso/1 deletes the aviso" do
      aviso = aviso_fixture()
      assert {:ok, %Aviso{}} = Avisos.delete_aviso(aviso)
      assert_raise Ecto.NoResultsError, fn -> Avisos.get_aviso!(aviso.id) end
    end

    test "change_aviso/1 returns a aviso changeset" do
      aviso = aviso_fixture()
      assert %Ecto.Changeset{} = Avisos.change_aviso(aviso)
    end
  end
end
