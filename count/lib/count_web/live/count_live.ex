defmodule CountWeb.CountLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    :timer.send_interval(1_000, :tick)
    {:ok, assign(socket, hello: :world, count: 0)}
  end

  def render(assigns) do
    ~H"""
    <h1>Hello, <%= @hello %>!</h1>
    <h2>If you dream it, we can count it.</h2>
    <p>Your count: <%= @count %></p>
    <button phx-click={ :inc }>Inc</button>
    """
  end

  def handle_info(:tick, socket) do
    {:noreply, inc(socket)}
  end

  def handle_event("inc", _params, socket) do
    {:noreply, inc(socket)}
  end

  defp inc(socket), do: assign(socket, count: socket.assigns.count + 1)
end
