defmodule EmergencyServer.NoticesTest do
  use EmergencyServer.DataCase

  alias EmergencyServer.Notices

  describe "notices" do
    alias EmergencyServer.Notices.Notice

    import EmergencyServer.NoticesFixtures

    @invalid_attrs %{title: nil, category: nil, author: nil, content: nil}

    test "list_notices/0 returns all notices" do
      notice = notice_fixture()
      assert Notices.list_notices() == [notice]
    end

    test "get_notice!/1 returns the notice with given id" do
      notice = notice_fixture()
      assert Notices.get_notice!(notice.id) == notice
    end

    test "create_notice/1 with valid data creates a notice" do
      valid_attrs = %{title: "some title", category: "notice", author: "some author", content: "some content"}

      assert {:ok, %Notice{} = notice} = Notices.create_notice(valid_attrs)
      assert notice.title == "some title"
      assert notice.category == "notice"
      assert notice.author == "some author"
      assert notice.content == "some content"
    end

    test "create_notice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notices.create_notice(@invalid_attrs)
    end

    test "update_notice/2 with valid data updates the notice" do
      notice = notice_fixture()
      update_attrs = %{title: "some updated title", category: "help_request", author: "some updated author", content: "some updated content"}

      assert {:ok, %Notice{} = notice} = Notices.update_notice(notice, update_attrs)
      assert notice.title == "some updated title"
      assert notice.category == "help_request"
      assert notice.author == "some updated author"
      assert notice.content == "some updated content"
    end

    test "update_notice/2 with invalid data returns error changeset" do
      notice = notice_fixture()
      assert {:error, %Ecto.Changeset{}} = Notices.update_notice(notice, @invalid_attrs)
      assert notice == Notices.get_notice!(notice.id)
    end

    test "delete_notice/1 deletes the notice" do
      notice = notice_fixture()
      assert {:ok, %Notice{}} = Notices.delete_notice(notice)
      assert_raise Ecto.NoResultsError, fn -> Notices.get_notice!(notice.id) end
    end

    test "change_notice/1 returns a notice changeset" do
      notice = notice_fixture()
      assert %Ecto.Changeset{} = Notices.change_notice(notice)
    end
  end
end
