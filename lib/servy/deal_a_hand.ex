defmodule DealAHand do
  @ranks ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
  @suits ["♣", "♦", "♥", "♠"]
  def deck do
    for rank <- @ranks, suit <- @suits, do: {rank, suit}
  end

  def deal_hand do
    deck()
    |> Enum.shuffle()
    |> Enum.take(13)
    |> IO.inspect()
  end

  def deal_four_hands do
    deck()
    |> Enum.shuffle()
    |> Enum.chunk_every(13)
    |> IO.inspect()
  end
end
