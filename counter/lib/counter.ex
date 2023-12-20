defmodule Counter do

  def start(initial_number) do
    spawn(fn ->  Counter.Server.run(initial_number) end)
  end

  def tick(pid, type) do
    send pid, {:tick, self(), type}
  end

  def state(pid) do
    send pid, {:state, self()}
    receive do
      {:state, value} -> value
    end
  end

end
