defmodule Discuss.ModelFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Discuss.Model` context.
  """

  @doc """
  Generate a unique topic title.
  """
  def unique_topic_title, do: "some title#{System.unique_integer([:positive])}"

  @doc """
  Generate a topic.
  """
  def topic_fixture(attrs \\ %{}) do
    {:ok, topic} =
      attrs
      |> Enum.into(%{
        title: unique_topic_title()
      })
      |> Discuss.Model.create_topic()

    topic
  end
end
