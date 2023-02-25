defmodule CountWeb.Counter do
  use CountWeb, :live_component

  alias Count.Boundary

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
    |> change(%{})
  end

  defp inc(%{assigns: %{counters: counters}} = socket, counter_name) do
    assign(socket, counters: Boundary.inc(counters, counter_name))
  end

  defp change(socket, params) do
    assign(socket, changeset: Boundary.validate(params, used_counter_names(socket)))
  end

  defp save(%{assigns: %{counters: counters}} = socket, params) do
    assign(socket, counters: Boundary.add(counters, params, used_counter_names(socket)))
  end

  defp used_counter_names(socket),
    do: Map.keys(socket.assigns.counters)
end
