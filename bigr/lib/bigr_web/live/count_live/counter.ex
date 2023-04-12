defmodule BigrWeb.CountLive.Counter do
  use BigrWeb, :live_component

  alias Bigr.Counter

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(counter: Counter.new())}
  end

  def handle_event("inc", _meta, socket) do
    {:noreply, assign(socket, counter: Counter.inc(socket.assigns.counter))}
  end

  def handle_event("dec", _meta, socket) do
    {:noreply, assign(socket, counter: Counter.dec(socket.assigns.counter))}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-sm rounded overflow-hidden shadow-lg">
      <div class="px-6 py-4">
        <div class="font-bold text-xl mb-2">Table <%= @table_number %></div>
        <p class="text-gray-700 text-base">
          count: <%= Counter.show(@counter) %>
        </p>
      </div>
      <div class="px-6 pt-4 pb-2">
        <.count_button click="inc" target={@myself}>Inc</.count_button>
        <.count_button click="dec" target={@myself}>Dec</.count_button>
      </div>
    </div>
    """
  end

  attr :click, :string, required: true
  attr :target, :any, required: true
  slot :inner_block, required: true

  defp count_button(assigns) do
    ~H"""
    <span
      class="inline-block bg-gray-200 rounded-full px-3 py-1 text-sm font-semibold text-gray-700 mr-2 mb-2"
      phx-click={@click}
      phx-target={@target}
    >
      <%= render_slot(@inner_block) %>
    </span>
    """
  end
end
