defmodule CountWeb.Counter do
  use CountWeb, :live_component

  alias Count.Boundary
  alias Count.Core
  alias Count.Tally

  # c - constructor

  # r - reducers

  def update(assigns, socket) do
    {:ok, init(socket, assigns)}
  end

  def handle_event("inc", %{"key" => counter_name}, socket) do
    {:noreply, inc(socket, counter_name)}
  end

  def handle_event("validate", %{"tally" => params}, socket) do
    {:noreply, change(socket, params)}
  end

  def handle_event("save", %{"tally" => params}, socket) do
    {:noreply, save(socket, params)}
  end

  def handle_info({:tick, counter_name}, socket) do
    {:noreply, inc(socket, counter_name)}
  end

  # c - converter

  def render(assigns) do
    ~H"""
    <div id="counter">
      <.form let={f} for={@changeset} phx-target={@myself} phx-change="validate" phx-submit="save">
        <%= label f, :name %>
        <%= text_input f, :name %>
        <%= error_tag f, :name %>

        <%= submit "Add", disabled: not @changeset.valid?() %>
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

  defp init(socket, assigns) do
    socket
    |> assign(assigns)
    |> assign(changeset: Tally.validate(%{}, Map.keys(assigns.counters)))
  end

  defp inc(socket, counter_name) do
    assign(socket, counters: Core.inc(socket.assigns.counters, counter_name))
  end

  defp change(socket, params) do
    used_names = Map.keys(socket.assigns.counters)

    changeset =
      params
      |> Tally.validate(used_names)
      |> Map.put(:action, :insert)

    assign(socket, changeset: changeset)
  end

  defp save(socket, params) do
    socket = change(socket, params)

    assign(socket, counters: Boundary.add(socket.assigns.counters, socket.assigns.changeset))
  end
end
