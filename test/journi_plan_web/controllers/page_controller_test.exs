defmodule JourniPlanWeb.PageControllerTest do
  use JourniPlanWeb.ConnCase
  alias JourniPlan.Accounts

  setup do
    # Register a test user
    {:ok, user} = Accounts.register_user(%{
      email: "test@example.com",
      password: "passwordpassword123"
    })

    # Log the user in by modifying the connection
    {:ok, conn: log_in_user(build_conn(), user), user: user}
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Your Itineraries"
  end
end
