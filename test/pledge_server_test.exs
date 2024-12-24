defmodule PledgeServerTest do
  use ExUnit.Case, async: true

  alias Servy.PledgeServer

  test "returns 3 most recent pledges and total" do
    PledgeServer.start()

    PledgeServer.create_pledge("jinx", 10)
    PledgeServer.create_pledge("vi", 20)
    PledgeServer.create_pledge("cait", 30)
    PledgeServer.create_pledge("maddie", 40)

    assert [{"maddie", 40}, {"cait", 30}, {"vi", 20}] = PledgeServer.recent_pledges()
    assert 90 = PledgeServer.total_pledged()
  end
end
