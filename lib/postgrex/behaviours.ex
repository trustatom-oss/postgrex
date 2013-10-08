defmodule Postgrex.Encoder do
  use Behaviour

  defcallback pre_encode(sender :: atom, oid :: integer, param :: term) :: term
  defcallback post_encode(sender :: atom, oid :: integer, param :: term, encoded :: binary | nil) :: binary
end

defmodule Postgrex.Decoder do
  use Behaviour

  defcallback decode(sender :: atom, oid :: integer, value :: binary, decoded :: term | nil) :: term
end
