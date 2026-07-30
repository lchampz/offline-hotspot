defmodule EmergencyServerWeb.NoticeLiveTest do
  use EmergencyServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import EmergencyServer.NoticesFixtures

  @create_attrs %{title: "some title", category: "notice", author: "some author", content: "some content"}
  @update_attrs %{title: "some updated title", category: "help_request", author: "some updated author", content: "some updated content"}
  @invalid_attrs %{title: nil, category: nil, author: nil, content: nil}
  defp create_notice(_) do
    notice = notice_fixture()

    %{notice: notice}
  end

  describe "Index" do
    setup [:create_notice]

    test "lists all notices", %{conn: conn, notice: notice} do
      {:ok, _index_live, html} = live(conn, ~p"/notices")

      assert html =~ "Notice Board"
      assert html =~ notice.title
    end

    test "saves new notice", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/notices")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New notice")
               |> render_click()
               |> follow_redirect(conn, ~p"/notices/new")

      assert render(form_live) =~ "New notice"

      assert form_live
             |> form("#notice-form", notice: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#notice-form", notice: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/notices")

      html = render(index_live)
      assert html =~ "Notice created successfully"
      assert html =~ "some title"
    end

    test "updates notice in listing", %{conn: conn, notice: notice} do
      {:ok, index_live, _html} = live(conn, ~p"/notices")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#notices-#{notice.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/notices/#{notice}/edit")

      assert render(form_live) =~ "Edit notice"

      assert form_live
             |> form("#notice-form", notice: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#notice-form", notice: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/notices")

      html = render(index_live)
      assert html =~ "Notice updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes notice in listing", %{conn: conn, notice: notice} do
      {:ok, index_live, _html} = live(conn, ~p"/notices")

      assert index_live |> element("#notices-#{notice.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#notices-#{notice.id}")
    end
  end

  describe "Show" do
    setup [:create_notice]

    test "displays notice", %{conn: conn, notice: notice} do
      {:ok, _show_live, html} = live(conn, ~p"/notices/#{notice}")

      assert html =~ "Notice posted on the community board"
      assert html =~ notice.title
    end

    test "updates notice and returns to show", %{conn: conn, notice: notice} do
      {:ok, show_live, _html} = live(conn, ~p"/notices/#{notice}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit notice")
               |> render_click()
               |> follow_redirect(conn, ~p"/notices/#{notice}/edit?return_to=show")

      assert render(form_live) =~ "Edit notice"

      assert form_live
             |> form("#notice-form", notice: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#notice-form", notice: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/notices/#{notice}")

      html = render(show_live)
      assert html =~ "Notice updated successfully"
      assert html =~ "some updated title"
    end
  end
end
