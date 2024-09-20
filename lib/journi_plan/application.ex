defmodule JourniPlan.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      JourniPlan.App,
      JourniPlanWeb.Telemetry,
      JourniPlan.Repo,
      {DNSCluster, query: Application.get_env(:journi_plan, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: JourniPlan.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: JourniPlan.Finch},
      # Start a worker by calling: JourniPlan.Worker.start_link(arg)
      # {JourniPlan.Worker, arg},
      # Start to serve requests, typically the last entry
      JourniPlanWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: JourniPlan.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JourniPlanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
