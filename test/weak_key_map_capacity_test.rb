# frozen_string_literal: true

require_relative 'test_helper'

using Capa

class WeakKeyMapCapacityTest < Minitest::Test
  prove_it!

  def test_empty_weak_key_map_has_capacity
    assert_operator ObjectSpace::WeakKeyMap.new.capacity, :>, 0
  end

  def test_capacity_gte_entry_count
    keys = Array.new(100) { Object.new }
    map = keys.each_with_object(ObjectSpace::WeakKeyMap.new) { |key, wkm| wkm[key] = true }

    assert_operator map.capacity, :>=, 100
  end

  def test_capacity_is_power_of_two
    keys = Array.new(50) { Object.new }
    map = keys.each_with_object(ObjectSpace::WeakKeyMap.new) { |key, wkm| wkm[key] = true }
    capacity = map.capacity

    assert_equal capacity, capacity & -capacity
  end

  def test_capacity_returns_integer
    assert_kind_of Integer, ObjectSpace::WeakKeyMap.new.capacity
  end
end
