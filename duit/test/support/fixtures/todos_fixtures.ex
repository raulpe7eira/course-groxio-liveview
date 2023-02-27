defmodule Duit.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Duit.Todos` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        done: true,
        name: "some name"
      })
      |> Duit.Todos.create_task()

    task
  end
end
