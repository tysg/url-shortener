defmodule Elx.Counter do
  use Agent
  alias Elx.Util

  def start_link(_opts) do
    initial_value = 1_599_647_941
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  def generate do
    uid = Agent.get_and_update(__MODULE__, fn i -> {i, i + 1} end)
    Util.base62_encode(uid)
  end
end
