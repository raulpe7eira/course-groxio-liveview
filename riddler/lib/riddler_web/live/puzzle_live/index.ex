defmodule RiddlerWeb.PuzzleLive.Index do
  use RiddlerWeb, :live_view

  alias Riddler.Game
  alias Riddler.Game.Puzzle

  @impl true
  def mount(_params, _session, socket) do
    Game.subscribe_puzzle_changed()
    {:ok, stream(socket, :puzzles, Game.list_puzzles())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :points, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Points")
    |> assign_puzzle(id)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Puzzle")
    |> assign_puzzle(id)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Puzzle")
    |> assign(:puzzle, %Puzzle{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Puzzles")
    |> assign(:puzzle, nil)
  end

  defp assign_puzzle(socket, id) do
    assign(socket, :puzzle, Game.get_puzzle!(id))
  end

  @impl true
  def handle_info({RiddlerWeb.PuzzleLive.FormComponent, {:saved, puzzle}}, socket) do
    {:noreply, stream_insert(socket, :puzzles, puzzle)}
  end

  @impl true
  def handle_info({:puzzle_changed, id}, %{assigns: %{puzzle: %{id: id}}} = socket) do
    {:noreply, assign_puzzle(socket, id)}
  end

  @impl true
  def handle_info({:puzzle_changed, _}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    puzzle = Game.get_puzzle!(id)
    {:ok, _} = Game.delete_puzzle(puzzle)

    {:noreply, stream_delete(socket, :puzzles, puzzle)}
  end
end
