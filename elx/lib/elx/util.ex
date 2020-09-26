defmodule Elx.Util do
  @moduledoc """
  Base62 encoder
  Copied from: https://github.com/otobus/event_bus/commit/956ffd93d854fb3a721aa7763c3da509cffedd41#diff-31f9094877d525a1b8387d4135042006R1
  """

  @mapping '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

  @doc """
  Converts given integer to base62
  """
  @spec base62_encode(integer()) :: String.t()
  def base62_encode(num) when num < 62 do
    <<Enum.at(@mapping, num)>>
  end

  def base62_encode(num) do
    base62_encode(div(num, 62)) <> base62_encode(rem(num, 62))
  end

  def hash_url(url) do
    :crypto.hash(:sha, url)
  end
end
