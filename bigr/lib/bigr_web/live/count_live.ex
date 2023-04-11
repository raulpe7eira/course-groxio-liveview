defmodule BigrWeb.CountLive do
  use BigrWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 0)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-4xl">Count <%= @count %></h1>
    <button phx-click="inc">Inc</button>
    """
  end

  def handle_event("inc", _meta, socket) do
    {:noreply, assign(socket, count: socket.assigns.count + 1)}
  end
end
