defmodule CountWeb.Counter do
  use CountWeb, :live_component

  alias Count.Core
  alias Count.Tally

  # c - constructor

  # r - reducers

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(changeset: Tally.validate(%{}, Map.keys(assigns.counters)))

    {:ok, socket}
  end

  def handle_event("inc", %{"key" => counter_name}, socket) do
    {:noreply, inc(socket, counter_name)}
  end

  def handle_event("validate", %{"tally" => params}, socket) do
    {:noreply, change(socket, params, Map.keys(socket.assigns.counters))}
  end

  def handle_event("add", %{"tally" => _params}, socket) do
    {:noreply, socket}
  end

  def handle_info({:tick, counter_name}, socket) do
    {:noreply, inc(socket, counter_name)}
  end

  # c - converter

  def render(assigns) do
    ~H"""
    <div id="counter">
      <.form let={f} for={@changeset} phx-target={@myself} phx-change="validate" phx-submit="add">
        <%= label f, :name %>
        <%= text_input f, :name %>
        <%= error_tag f, :name %>

        <%= submit "Add" %>
      </.form>

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

  defp change(socket, params, used_names) do
    changeset =
      params
      |> Tally.validate(used_names)
      |> Map.put(:action, :insert)

    assign(socket, changeset: changeset)
  end
end
