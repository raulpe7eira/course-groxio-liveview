defmodule CountWeb.Counter do
  use CountWeb, :live_component

  alias Count.Core

  # c - constructor

  def update(assigns, socket) do
    :timer.send_interval(1_000, :tick)
    {:ok, assign(socket, assigns)}
  end

  # r - reducers

  def handle_info({:tick, counter_name}, socket) do
    {:noreply, inc(socket, counter_name)}
  end

  def handle_event("inc", %{"key" => counter_name}, socket) do
    {:noreply, inc(socket, counter_name)}
  end

  # c - converter

  def render(assigns) do
    ~H"""
    <div id="counter">
      <%= for {name, _count} = counter <- @counters do %>
      <%= render_slot(@inner_block, counter) %>
      <button phx-click={ :inc } phx-target={@myself} phx-value-key={name}>Inc</button>
      <% end %>
      <pre><%= inspect @counters %></pre>
    </div>
    """
  end

  # private functions

  defp inc(socket, counter_name) do
    assign(socket, counters: Core.inc(socket.assigns.counters, counter_name))
  end
end
