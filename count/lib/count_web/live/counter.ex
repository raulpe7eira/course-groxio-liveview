defmodule CountWeb.Counter do
  use CountWeb, :live_component

  alias Count.Boundary

  # c - constructor

  def mount(socket) do
    {:ok, do_init(socket)}
  end

  # r - reducers

  def update(%{tick: true}, socket) do
    # receive message from live_view (`count_live.ex` from `handle_info/2`)
    {:ok, tick(socket)}
  end

  def update(assigns, socket) do
    {:ok, do_update(socket, assigns)}
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

  # c - converter

  def render(assigns) do
    ~H"""
    <div id="counter">
      <pre><%= inspect @counters %></pre>

      <%= for {name, _count} = counter <- @counters do %>
      <p>
        <%= render_slot(@inner_block, counter) %>
        <button phx-click={ :inc } phx-target={@myself} phx-value-key={name}>Inc</button>
      </p>
      <% end %>

      <%= if @adding do %>
      <.form let={f} for={@changeset} phx-target={@myself} phx-change="validate" phx-submit="save">
        <%= label f, :name %>
        <%= text_input f, :name %>
        <%= error_tag f, :name %>

        <%= label f, :count %>
        <%= text_input f, :count %>
        <%= error_tag f, :count %>

        <%= submit "Add", disabled: not @changeset.valid?() %>
      </.form>
      <% else %>
      <%= live_patch "Add counter", to: "/count/add" %>
      <% end %>
    </div>
    """
  end

  # private functions

  defp do_init(socket) do
    assign(socket, counters: Boundary.new_counter([]))
  end

  defp do_update(socket, assigns) do
    socket
    |> assign(assigns)
    |> change(%{})
  end

  defp tick(socket) do
    for counter_name <- used_counter_names(socket), reduce: socket do
      socket -> inc(socket, counter_name)
    end
  end

  defp inc(%{assigns: %{counters: counters}} = socket, counter_name) do
    # pub_sub experiment
    CountWeb.Endpoint.broadcast("count", "inc", {counter_name, 1})

    assign(socket, counters: Boundary.inc(counters, counter_name))
  end

  defp change(socket, params) do
    assign(socket, changeset: Boundary.validate(params, used_counter_names(socket)))
  end

  defp save(%{assigns: %{counters: counters}} = socket, params) do
    socket
    |> assign(counters: Boundary.add(counters, params, used_counter_names(socket)))
    |> push_patch(to: "/count")
  end

  defp used_counter_names(socket),
    do: Map.keys(socket.assigns.counters)
end
