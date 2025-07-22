defmodule MyLibraryy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MyLibraryyWeb.Telemetry,
      MyLibraryy.Repo,
      {DNSCluster, query: Application.get_env(:my_libraryy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MyLibraryy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MyLibraryy.Finch},
      # Start a worker by calling: MyLibraryy.Worker.start_link(arg)
      # {MyLibraryy.Worker, arg},
      # Start to serve requests, typically the last entry
      MyLibraryyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyLibraryy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MyLibraryyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
