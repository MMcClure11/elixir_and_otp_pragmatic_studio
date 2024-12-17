defmodule Servy.Fetcher do
  def async(fun) do
    parent = self()
    spawn(fn -> send(parent, {self(), :result, fun.()}) end)
  end

  # Similar to Task’s await function
  # But Task.async/1 returns a task struct that can be passed to Task.await/1
  # and it will match on pids
  def get_result(pid) do
    receive do
      {^pid, :result, value} -> value
    after
      2000 -> raise "Timed out!"
    end
  end
end
