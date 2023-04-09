defmodule MemzWeb.GameLive.Play do
  use MemzWeb, :live_view

  alias Memz.BestScores
  alias Memz.BestScores.Score
  alias Memz.Game

  @default_text ""
  @default_steps 0

  def mount(_params, _session, %{assigns: %{live_action: :over}} = socket) do
    {:ok, push_redirect(socket, to: "/game/welcome")}
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       eraser: nil,
       changeset: Game.change_game(default_game(), %{}),
       guess_changeset: Game.guess_changeset()
     )}
  end

  def render(%{live_action: :over} = assigns) do
    ~L"""
    <h1>Game over!</h1>
    <h2>Your score: <%= @eraser.score %></h2>

    <p>Enter your initials:</p>
    <%= f = form_for @score_changeset, "#",
      phx_change: "validate_score",
      phx_submit: "save_score" %>

      <%= label f, :score %>
      <%= number_input f, :score, disabled: true %>
      <%= error_tag f, :score %>

      <%= label f, :initials %>
      <%= text_input f, :initials %>
      <%= error_tag f, :initials %>

      <%= submit "Submit Score", disabled: !@score_changeset.valid? %>
    </form>

    <button phx-click="play">Play again?</button>
    """
  end

  def render(%{eraser: nil} = assigns) do
    ~L"""
    <h1>What do you want to memorize?</h1>

    <%= f = form_for @changeset, "#",
      phx_change: "validate",
      phx_submit: "memorize" %>

      <%= label f, :steps %>
      <%= number_input f, :steps %>
      <%= error_tag f, :steps %>

      <%= label f, :text %>
      <%= text_input f, :text %>
      <%= error_tag f, :text %>

      <%= submit "Memorize", disabled: !@changeset.valid? %>
    </form>
    """
  end

  def render(%{eraser: %{status: :erasing}} = assigns) do
    ~L"""
    <h1>Memorize this much:</h1>

    <pre><%= @eraser.text %></pre>
    <button phx-click="erase">Erase some</button>

    <%= score(@eraser) %>
    """
  end

  def render(%{eraser: %{status: :guessing}} = assigns) do
    ~L"""
    <h1>Type the text, filling in the blanks!</h1>

    <pre><%= @eraser.text %></pre>
    <%= f = form_for @guess_changeset, "#",
      phx_submit: "score",
      as: "guess" %>

      <%= label f, :text %>
      <%= text_input f, :text %>
      <%= error_tag f, :text %>

      <%= submit "Type the text" %>
    </form>
    """
  end

  def render(%{eraser: %{status: :finished}} = assigns) do
    ~L"""
    <h1>Nice job! See how you did:</h1>

    <pre><%= score(@eraser) %></pre>
    """
  end

  def handle_event("validate", %{"game" => params}, socket) do
    {:noreply, validate(socket, params)}
  end

  def handle_event("memorize", %{"game" => params}, socket) do
    {:noreply, memorize(socket, params)}
  end

  def handle_event("erase", _meta, socket) do
    {:noreply, erase(socket)}
  end

  def handle_event("score", %{"guess" => %{"text" => guess}}, socket) do
    {:noreply,
     socket
     |> score(guess)
     |> maybe_finish()}
  end

  def handle_event("validate_score", %{"score" => params}, socket) do
    {:noreply, validate_score(socket, params)}
  end

  def handle_event("save_score", %{"score" => params}, socket) do
    {:noreply, save_score(socket, params)}
  end

  def handle_params(_params, _meta, socket) do
    {:noreply, socket}
  end

  def score(eraser) do
    """
    <h2>Your score so far (lower is better): #{eraser.score}</h2>
    """
    |> Phoenix.HTML.raw()
  end

  defp default_game(), do: Game.new_game(@default_text, @default_steps)

  defp validate(socket, params) do
    assign(socket, changeset: Game.change_game(Game.new_game("", 5), params))
  end

  defp memorize(socket, params) do
    eraser =
      default_game()
      |> Game.change_game(params)
      |> Game.create()

    assign(socket, eraser: eraser)
  end

  defp erase(socket) do
    assign(socket, eraser: Game.erase(socket.assigns.eraser))
  end

  defp score(socket, guess) do
    assign(socket, eraser: Game.score(socket.assigns.eraser, guess))
  end

  defp maybe_finish(%{assigns: %{eraser: %{status: :finished, score: score}}} = socket) do
    socket
    |> assign(score_changeset: BestScores.change_score(%Score{score: score}, %{}))
    |> push_patch(to: "/game/over")
  end

  defp maybe_finish(socket), do: socket

  defp validate_score(socket, params) do
    changeset =
      %Score{score: socket.assigns.eraser.score}
      |> BestScores.change_score(params)
      |> Map.put(:action, :validate)

    assign(socket, score_changeset: changeset)
  end

  defp save_score(socket, params) do
    BestScores.create_score(params["initials"], socket.assigns.eraser.score)
    push_redirect(socket, to: "/game/welcome")
  end
end
