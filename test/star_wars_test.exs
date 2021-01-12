defmodule StarWarsTest do
  use ExUnit.Case
  doctest StarWars

  test "greets the world" do
    assert StarWars.hello() == :world
  end
end
