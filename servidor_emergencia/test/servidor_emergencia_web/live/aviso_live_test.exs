defmodule ServidorEmergenciaWeb.AvisoLiveTest do
  use ServidorEmergenciaWeb.ConnCase

  import Phoenix.LiveViewTest
  import ServidorEmergencia.AvisosFixtures

  @create_attrs %{titulo: "some titulo", categoria: "recado", autor: "some autor", conteudo: "some conteudo"}
  @update_attrs %{titulo: "some updated titulo", categoria: "pedido_ajuda", autor: "some updated autor", conteudo: "some updated conteudo"}
  @invalid_attrs %{titulo: nil, categoria: nil, autor: nil, conteudo: nil}
  defp create_aviso(_) do
    aviso = aviso_fixture()

    %{aviso: aviso}
  end

  describe "Index" do
    setup [:create_aviso]

    test "lists all avisos", %{conn: conn, aviso: aviso} do
      {:ok, _index_live, html} = live(conn, ~p"/avisos")

      assert html =~ "Quadro de Avisos"
      assert html =~ aviso.titulo
    end

    test "saves new aviso", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/avisos")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "Novo aviso")
               |> render_click()
               |> follow_redirect(conn, ~p"/avisos/new")

      assert render(form_live) =~ "Novo aviso"

      assert form_live
             |> form("#aviso-form", aviso: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#aviso-form", aviso: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/avisos")

      html = render(index_live)
      assert html =~ "Aviso criado com sucesso"
      assert html =~ "some titulo"
    end

    test "updates aviso in listing", %{conn: conn, aviso: aviso} do
      {:ok, index_live, _html} = live(conn, ~p"/avisos")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#avisos-#{aviso.id} a", "Editar")
               |> render_click()
               |> follow_redirect(conn, ~p"/avisos/#{aviso}/edit")

      assert render(form_live) =~ "Editar aviso"

      assert form_live
             |> form("#aviso-form", aviso: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#aviso-form", aviso: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/avisos")

      html = render(index_live)
      assert html =~ "Aviso atualizado com sucesso"
      assert html =~ "some updated titulo"
    end

    test "deletes aviso in listing", %{conn: conn, aviso: aviso} do
      {:ok, index_live, _html} = live(conn, ~p"/avisos")

      assert index_live |> element("#avisos-#{aviso.id} a", "Excluir") |> render_click()
      refute has_element?(index_live, "#avisos-#{aviso.id}")
    end
  end

  describe "Show" do
    setup [:create_aviso]

    test "displays aviso", %{conn: conn, aviso: aviso} do
      {:ok, _show_live, html} = live(conn, ~p"/avisos/#{aviso}")

      assert html =~ "Aviso publicado no quadro comunitário"
      assert html =~ aviso.titulo
    end

    test "updates aviso and returns to show", %{conn: conn, aviso: aviso} do
      {:ok, show_live, _html} = live(conn, ~p"/avisos/#{aviso}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Editar aviso")
               |> render_click()
               |> follow_redirect(conn, ~p"/avisos/#{aviso}/edit?return_to=show")

      assert render(form_live) =~ "Editar aviso"

      assert form_live
             |> form("#aviso-form", aviso: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#aviso-form", aviso: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/avisos/#{aviso}")

      html = render(show_live)
      assert html =~ "Aviso atualizado com sucesso"
      assert html =~ "some updated titulo"
    end
  end
end
