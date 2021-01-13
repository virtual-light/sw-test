defmodule Mix.Tasks.Fetch do
  use Mix.Task

  @output_delimiter "------------------------------"

  def run(_args) do
    {:ok, _} = Application.ensure_all_started(:star_wars)
    {starships, pilots} = StarWars.run()
    print_result(starships, pilots)
  end

  defp print_result(starships, pilots) do
    print_catalog("Starships", starships)
    IO.puts("\n")
    print_catalog("Pilots:", pilots)
  end

  defp print_catalog(name, list) do
    IO.puts(@output_delimiter)
    IO.puts("#{name}:")
    IO.puts(@output_delimiter)

    list
    |> Stream.flat_map(&["Name: #{&1.name}", "URL: #{&1.url}", @output_delimiter])
    |> Stream.drop(-1)
    |> Enum.each(&IO.puts/1)
  end
end
