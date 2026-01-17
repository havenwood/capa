# frozen_string_literal: true

require_relative 'test_helper'

using Capa

class HashCapacityTest < Minitest::Test
  prove_it!

  def test_empty_hash_uses_ar_mode
    assert_equal 8, {}.capacity
  end

  def test_small_hash_uses_ar_mode
    hash = {a: 1, b: 2, c: 3}

    assert_equal 8, hash.capacity
  end

  def test_large_hash_capacity_matches_requested
    hash = Hash.new(capacity: 1024)

    assert_equal 1024, hash.capacity
  end

  def test_capacity_is_power_of_two_in_st_mode
    hash = Hash.new(capacity: 1024)
    capacity = hash.capacity

    assert_equal capacity, capacity & -capacity
  end

  def test_capacity_returns_integer
    assert_kind_of Integer, {}.capacity
  end
end
