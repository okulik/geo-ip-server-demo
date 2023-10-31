defmodule GeoIpServerDemoWeb.PageControllerTest do
  use GeoIpServerDemoWeb.ConnCase

  import Mock

  alias Httpoison

  test "GET /", %{conn: conn} do
    body = """
      {
        "records": [
          {
            "country_iso_code": "NO",
            "country_name": "Norway"
          }
        ]
      }
    """

    with_mock(HTTPoison,
      get: fn _, _, _ -> {:ok, %HTTPoison.Response{status_code: 200, body: body}} end
    ) do
      conn = get(conn, ~p"/")
      assert html_response(conn, 200) =~ "no.png"
    end
  end
end
