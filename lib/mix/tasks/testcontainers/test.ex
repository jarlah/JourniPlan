# TODO: Remove when Testcontainers releases a new version with a similar feature
# See: https://github.com/testcontainers/testcontainers-elixir/pull/124
defmodule Mix.Tasks.Testcontainers.Test do
  use Mix.Task
  alias Testcontainers.PostgresContainer

  @shortdoc "Runs tests with a Postgres container"
  def run(_) do
    Application.ensure_all_started(:tesla)
    Application.ensure_all_started(:hackney)

    {:ok, _} = Testcontainers.start_link()
    config = PostgresContainer.new()
    {:ok, container} = Testcontainers.start_container(config)

    try do
      {output, exit_code} = System.cmd("mix", ["test"], env: [
        {"POSTGRES_USER", "test"},
        {"POSTGRES_PASSWORD", "test"},
        {"POSTGRES_HOST", Testcontainers.get_host()},
        {"POSTGRES_PORT", PostgresContainer.port(container) |> Integer.to_string()}
      ])
      if exit_code != 0 do
        IO.puts(output)
        raise "\u274c Tests failed"
      end
      IO.puts("\u2705 Tests passed")
    after
      Testcontainers.stop_container(container.container_id)
    end
  end
end
