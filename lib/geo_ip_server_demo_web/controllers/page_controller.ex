defmodule GeoIpServerDemoWeb.PageController do
  use GeoIpServerDemoWeb, :controller

  require Logger

  @image_prefix "https://flagcdn.com/256x192/"

  def home(conn, _params) do
    headers = [
      Authorization: get_basic_auth_token(),
      Accept: "Application/json; Charset=utf-8"
    ]

    {country_code, country_name} =
      conn
      |> geo_ip_server_query
      |> HTTPoison.get(headers, [])
      |> handle_response

    Logger.info(
      "geoips: ip #{conn_remote_ip(conn)}, country_code #{country_code}, country_name #{country_name}"
    )

    render(conn, :home,
      layout: false,
      image_src: image_src(country_code),
      country_name: country_name
    )
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    rec =
      body
      |> Jason.decode!()
      |> Map.get("records")
      |> hd()

    {rec["country_iso_code"], rec["country_name"]}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 404}}) do
    Logger.warning("No geoip data found")
    {nil, nil}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    Logger.error("Error getting geoip data: #{inspect(reason)}")
    {nil, nil}
  end

  defp geo_ip_server_query(conn) do
    "#{Application.get_env(:geo_ip_server_demo, GeoIpServer)[:geoips_url]}#{conn_remote_ip(conn)}"
  end

  defp conn_remote_ip(conn) do
    to_string(:inet_parse.ntoa(conn.remote_ip))
  end

  defp get_basic_auth_token do
    username = Application.get_env(:geo_ip_server_demo, GeoIpServer)[:auth_username]
    password = Application.get_env(:geo_ip_server_demo, GeoIpServer)[:auth_password]

    "Basic " <> Base.encode64("#{username}:#{password}")
  end

  defp image_src(country_code) do
    "#{@image_prefix}#{String.downcase(country_code)}.png"
  end
end
