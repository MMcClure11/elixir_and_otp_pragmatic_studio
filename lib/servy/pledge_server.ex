defmodule Servy.PledgeServer do
  @name :pledge_server

  # Client Interface
  def start(initial_state \\ []) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state])
    Process.register(pid, @name)
    pid
  end

  def create_pledge(name, amount) do
    send(@name, {self(), :create_pledge, name, amount})

    receive do
      {:response, status} -> status
    end
  end

  def recent_pledges do
    # Returns the most recent pledges (our cache)
    send(@name, {self(), :recent_pledges})

    receive do
      {:response, pledges} -> pledges
    end
  end

  def total_pledged do
    send(@name, {self(), :total_pledged})

    receive do
      {:response, total} -> total
    end
  end

  # Server
  def listen_loop(state) do
    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        most_recent_pledges = Enum.take(state, 2)
        new_state = [{name, amount} | most_recent_pledges]
        send(sender, {:response, id})
        listen_loop(new_state)

      {sender, :recent_pledges} ->
        send(sender, {:response, state})
        listen_loop(state)

      {sender, :total_pledged} ->
        total = Enum.map(state, &elem(&1, 1)) |> Enum.sum()
        send(sender, {:response, total})
        listen_loop(state)

      unexpected ->
        IO.puts("unexpected message: #{inspect(unexpected)}")
        listen_loop(state)
    end
  end

  defp send_pledge_to_service(_name, _amount) do
    # Code goes here to send pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

defmodule Servy.Scratch do
  alias Servy.PledgeServer

  def server do
    pid = PledgeServer.start()

    send(pid, {:stop, "hammertime"})

    IO.inspect(PledgeServer.create_pledge("jinx", 10))
    IO.inspect(PledgeServer.create_pledge("vi", 20))
    IO.inspect(PledgeServer.create_pledge("vander", 30))
    IO.inspect(PledgeServer.create_pledge("cait", 40))
    IO.inspect(PledgeServer.create_pledge("victor", 50))

    IO.inspect(PledgeServer.recent_pledges())

    IO.inspect(PledgeServer.total_pledged())

    IO.inspect(Process.info(pid, :messages))
  end
end
