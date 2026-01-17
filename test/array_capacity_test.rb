# frozen_string_literal: true

require_relative 'test_helper'

using Capa

class ArrayCapacityTest < Minitest::Test
  prove_it!

  def test_empty_array_has_capacity
    assert_operator [].capacity, :>, 0
  end

  def test_embedded_array_capacity_gte_size
    array = [1, 2, 3]

    assert_operator array.capacity, :>=, array.size
  end

  def test_heap_allocated_array_capacity_gte_size
    array = Array.new(1000)

    assert_operator array.capacity, :>=, array.size
  end

  def test_capacity_grows_when_exceeding_current
    array = Array.new(100)
    initial_capacity = array.capacity
    (initial_capacity + 1).times { array << 1 }

    assert_operator array.capacity, :>, initial_capacity
  end

  def test_capacity_returns_integer
    assert_kind_of Integer, [].capacity
  end
end
