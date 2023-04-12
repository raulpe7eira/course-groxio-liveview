defmodule BigrWeb.CountLive.Counter do
  use BigrWeb, :live_component

  alias Bigr.Counter

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(counter: Counter.new())}
  end

  def handle_event("inc", %{"inc-by" => inc_by}, socket) do
    by = String.to_integer(inc_by)

    {:noreply, assign(socket, counter: Counter.inc(socket.assigns.counter, by))}
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
        <.count_button target={@myself}>Inc</.count_button>
        <.count_button target={@myself} by={-1}>Dec</.count_button>
      </div>
    </div>
    """
  end

  attr :target, :any, required: true
  attr :by, :integer, default: 1
  slot :inner_block, required: true

  defp count_button(assigns) do
    ~H"""
    <span
      class="inline-block bg-gray-200 rounded-full px-3 py-1 text-sm font-semibold text-gray-700 mr-2 mb-2"
      phx-click="inc"
      phx-target={@target}
      phx-value-inc-by={@by}
    >
      <%= render_slot(@inner_block) %>
    </span>
    """
  end
end
