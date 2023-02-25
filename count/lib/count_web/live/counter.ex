defmodule CountWeb.Counter do
  use CountWeb, :live_component

  alias Count.Core

  # c - constructor

  def update(assigns, socket) do
    :timer.send_interval(1_000, :tick)
    {:ok, assign(socket, assigns)}
  end

  # r - reducers

  def handle_info(:tick, socket) do
    {:noreply, inc(socket)}
  end

  def handle_event("inc", _params, socket) do
    {:noreply, inc(socket)}
  end

  # c - converter

  def render(assigns) do
    ~H"""
    <div id="counter">
      <p>Your count: <%= @counter.count %></p>
      <button phx-click={ :inc } phx-target={@myself}>Inc</button>
    </div>
    """
  end

  # private functions

  defp inc(socket) do
    assign(socket, counter: Core.inc(socket.assigns.counter))
  end
end
