defmodule EmergencyServer.NoticesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmergencyServer.Notices` context.
  """

  @doc """
  Generate a notice.
  """
  def notice_fixture(attrs \\ %{}) do
    {:ok, notice} =
      attrs
      |> Enum.into(%{
        author: "some author",
        category: "notice",
        content: "some content",
        title: "some title"
      })
      |> EmergencyServer.Notices.create_notice()

    notice
  end
end
