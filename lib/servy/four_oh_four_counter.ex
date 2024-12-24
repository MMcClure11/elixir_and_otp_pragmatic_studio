defmodule Servy.FourOhFourCounter do
  @name :four_oh_four_counter

  # Client Interface
  def start(initial_state \\ %{}) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state])
    Process.register(pid, @name)
    pid
  end

  def bump_count(route) do
    send(@name, {self(), :bump_count, route})

    receive do
      {:response, status} -> status
    end
  end

  def get_count(route) do
    send(@name, {self(), :get_count, route})

    receive do
      {:response, pledges} -> pledges
    end
  end

  def get_counts do
    send(@name, {self(), :get_counts})

    receive do
      {:response, pledges} -> pledges
    end
  end

  # Server
  def listen_loop(state) do
    receive do
      {sender, :bump_count, route} ->
        current_count_for_route = Map.get(state, route, 0)
        new_state = Map.put(state, route, current_count_for_route + 1)
        send(sender, {:response, new_state})
        listen_loop(new_state)

      {sender, :get_count, route} ->
        send(sender, {:response, Map.get(state, route)})
        listen_loop(state)

      {sender, :get_counts} ->
        send(sender, {:response, state})
        listen_loop(state)

      unexpected ->
        IO.puts("unexpected message: #{inspect(unexpected)}")
        listen_loop(state)
    end
  end
end
