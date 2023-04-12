defmodule BigrWeb.CountLive do
  use BigrWeb, :live_view

  alias Bigr.Counter

  def mount(_params, _session, socket) do
    {:ok, assign(socket, counter: Counter.new())}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-4xl">Count <%= Counter.show(@counter) %></h1>
    <button
      phx-click="inc"
      class="rounded-lg bg-zinc-900 hover:bg-zinc-700
      py-2 px-3 text-sm font-semibold leading-6
      text-white active:text-white/80"
    >
      Inc
    </button>
    <button
      phx-click="dec"
      class="rounded-lg bg-zinc-900 hover:bg-zinc-700
      py-2 px-3 text-sm font-semibold leading-6
      text-white active:text-white/80"
    >
      Dec
    </button>

    <hr />

    <.game_grid>
      <%= for t <- 1..12 do %>
        <.game table_number={t} />
      <% end %>
    </.game_grid>
    """
  end

  def handle_event("inc", _meta, socket) do
    {:noreply, assign(socket, counter: Counter.inc(socket.assigns.counter))}
  end

  def handle_event("dec", _meta, socket) do
    {:noreply, assign(socket, counter: Counter.dec(socket.assigns.counter))}
  end

  attr :table_number, :integer, required: true

  defp game(assigns) do
    ~H"""
    <div><%= @table_number %></div>
    """
  end

  slot :inner_block

  defp game_grid(assigns) do
    ~H"""
    <div class="grid grid-cols-3 gap-4">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
