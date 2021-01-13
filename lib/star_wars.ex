defmodule StarWars do
  @type item :: %{url: String.t(), name: String.t()}

  @spec run() :: {starships :: [item], pilots :: [item]}
  def run do
    {starships, pilots_urls} = get_starships_and_pilots_urls("https://swapi.dev/api/starships/")
    pilots = get_pilots(pilots_urls)

    {starships, pilots}
  end

  defp get_starships_and_pilots_urls(url, acc_ships \\ [], acc_pilots_urls \\ []) do
    result =
      url
      |> http_get()
      |> process_starships_response()

    acc_ships = result.ships ++ acc_ships
    acc_pilots_urls = result.pilots_urls ++ acc_pilots_urls

    case Map.get(result, :next) do
      nil ->
        {acc_ships, Enum.uniq(acc_pilots_urls)}

      url ->
        get_starships_and_pilots_urls(url, acc_ships, acc_pilots_urls)
    end
  end

  def process_starships_response(response) do
    {ships, pilots_urls} =
      Enum.reduce(response["results"], {[], []}, fn result, {ships, pilots} = acc ->
        case Map.get(result, "pilots") do
          [] ->
            acc

          pilots_urls ->
            {[%{name: result["name"], url: result["url"]} | ships], pilots_urls ++ pilots}
        end
      end)

    %{ships: ships, pilots_urls: Enum.uniq(pilots_urls), next: response["next"]}
  end

  defp get_pilots(pilots_urls) do
    pilots_urls
    |> Task.async_stream(&http_get/1)
    |> Enum.map(fn {:ok, response} -> %{name: response["name"], url: response["url"]} end)
  end

  defp http_get(url) do
    %{body: body, status_code: 200} = HTTPoison.get!(url, [], follow_redirect: true)
    Jason.decode!(body)
  end
end
