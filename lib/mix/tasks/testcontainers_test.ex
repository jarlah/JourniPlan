# lib/mix/tasks/custom_test.ex
defmodule Mix.Tasks.TestcontainersTest do
  use Mix.Task
  alias Testcontainers.PostgresContainer

  @shortdoc "Runs tests with a Postgres container"
  def run(_) do
    Application.ensure_all_started(:tesla)
    Application.ensure_all_started(:hackney)

    # Start Testcontainers
    {:ok, _} = Testcontainers.start_link()

    # Configure and start a Postgres container
    config = PostgresContainer.new()
    {:ok, container} = Testcontainers.start_container(config)

    # Get the connection URL
    app_database_url = "postgres://test:test@#{Testcontainers.get_host()}:#{PostgresContainer.port(container)}/app_test"
    cmd_database_url = "postgres://test:test@#{Testcontainers.get_host()}:#{PostgresContainer.port(container)}/cmd_test"

    try do
      {output, exit_code} = System.cmd("mix", ["test"], env: [{"APP_DATABASE_URL", app_database_url}, {"COMMANDED_DATABASE_URL", cmd_database_url}])
      if exit_code != 0 do
        IO.puts(output)
        raise "\u274c Tests failed"
      end
      IO.puts("\u2705 Tests passed")
    after
      # Stop the container
      Testcontainers.stop_container(container.container_id)
    end
  end
end
