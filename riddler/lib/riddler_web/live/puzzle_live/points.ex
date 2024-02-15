defmodule RiddlerWeb.PuzzleLive.Points do
  use RiddlerWeb, :live_component

  alias Riddler.Game

  @impl true
  def update(%{puzzle: puzzle} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_grid(puzzle)}
  end

  @impl true
  def handle_event("toggle-rect", %{"x" => x, "y" => y}, socket) do
    {:noreply, toggle_rect(socket, x, y)}
  end

  @impl true
  def handle_event("toggle", _params, socket) do
    {:noreply, toggle(socket)}
  end

  @impl true
  def handle_event("save", _params, socket) do
    {:noreply, save(socket)}
  end

  defp assign_grid(socket, puzzle) do
    points = Enum.map(puzzle.points, &{&1.x, &1.y})

    grid =
      for x <- 1..puzzle.width, y <- 1..puzzle.height, into: %{} do
        {{x, y}, {x, y} in points}
      end

    assign(socket, grid: grid)
  end

  defp toggle_rect(socket, x, y) do
    grid = socket.assigns.grid

    x = String.to_integer(x)
    y = String.to_integer(y)

    new_grid = Map.put(grid, {x, y}, !grid[{x, y}])

    assign(socket, grid: new_grid)
  end

  defp toggle(socket) do
    toggled_grid =
      socket.assigns.grid
      |> Enum.map(fn {point, alive} -> {point, !alive} end)
      |> Enum.into(%{})

    assign(socket, grid: toggled_grid)
  end

  defp save(socket) do
    puzzle = socket.assigns.puzzle

    points =
      socket.assigns.grid
      |> Enum.filter(fn {_, alive} -> alive end)
      |> Enum.map(fn {point, _} -> point end)

    Game.save_puzzle_points(puzzle, points)

    socket
    |> put_flash(:info, "Points saved successfully")
    |> push_patch(to: socket.assigns.patch)
  end

  attr :x, :integer, required: true
  attr :y, :integer, required: true
  attr :myself, :any, required: true
  attr :alive, :boolean, default: false

  def rect(assigns) do
    ~H"""
    <rect
      x={@x * 10}
      y={@y * 10}
      width="10"
      height="10"
      rx="2"
      fill={fill_color(@alive)}
      class="hover:opacity-60"
      phx-click="toggle-rect"
      phx-value-x={@x}
      phx-value-y={@y}
      phx-target={@myself}
    />
    """
  end

  defp fill_color(true), do: "black"
  defp fill_color(false), do: "white"
end
