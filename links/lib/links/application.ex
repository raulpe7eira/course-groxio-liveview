defmodule Links.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LinksWeb.Telemetry,
      # Start the Ecto repository
      Links.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Links.PubSub},
      # Start Finch
      {Finch, name: Links.Finch},
      # Start the Endpoint (http/https)
      LinksWeb.Endpoint
      # Start a worker by calling: Links.Worker.start_link(arg)
      # {Links.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Links.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LinksWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
