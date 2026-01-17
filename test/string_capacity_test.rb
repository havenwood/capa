# frozen_string_literal: true

require_relative 'test_helper'

using Capa

class StringCapacityTest < Minitest::Test
  prove_it!

  def test_empty_string_has_capacity
    assert_operator (+'').capacity, :>, 0
  end

  def test_embedded_string_capacity_gte_size
    string = +'hello'

    assert_operator string.capacity, :>=, string.bytesize
  end

  def test_heap_allocated_string_capacity_gte_requested
    string = String.new(capacity: 1000)

    assert_operator string.capacity, :>=, 1000
  end

  def test_capacity_preserved_after_clear
    string = String.new(capacity: 100)
    capacity_before = string.capacity
    string.clear

    assert_equal capacity_before, string.capacity
  end

  def test_capacity_grows_with_concat
    string = +''
    initial_capacity = string.capacity
    string << ('x' * (initial_capacity + 1))

    assert_operator string.capacity, :>, initial_capacity
  end

  def test_capacity_returns_integer
    assert_kind_of Integer, ''.capacity
  end
end
