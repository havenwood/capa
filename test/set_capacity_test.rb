# frozen_string_literal: true

require_relative 'test_helper'

using Capa

class SetCapacityTest < Minitest::Test
  prove_it!

  def test_empty_set_has_capacity
    assert_operator Set.new.capacity, :>, 0
  end

  def test_set_capacity_gte_size
    set = Set.new(1..100)

    assert_operator set.capacity, :>=, set.size
  end

  def test_large_set_has_larger_capacity
    small_set = Set.new(1..10)
    large_set = Set.new(1..1000)

    assert_operator large_set.capacity, :>, small_set.capacity
  end

  def test_capacity_is_power_of_two
    set = Set.new(1..100)
    capacity = set.capacity

    assert_equal capacity, capacity & -capacity
  end

  def test_capacity_returns_integer
    assert_kind_of Integer, Set.new.capacity
  end
end
