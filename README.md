# Capa

Introspect the memory capacity of an Array, Hash, Set or String in Ruby. Implemented as refinements using Fiddle.

Capa provides a `capacity` instance method for:
- `Array` (embedded and heap-allocated)
- `String` (embedded and heap-allocated)
- `Hash` (AR and ST modes)
- `Set`
- `ObjectSpace::WeakKeyMap`

## Installation

```bash
gem install capa
```

## Usage

```ruby
require 'capa'

using Capa

string = String.new(capacity: 1024)
string.capacity       # => 1024
string.clear.capacity # => 16

hash = Hash.new(capacity: 1024)
hash.capacity         # => 1024
hash.clear.capacity   # => 2

array = Array.new(1024)
array.capacity        # => 1024
array.clear.capacity  # => 32

set = Set.new(1..1024)
set.capacity          # => 1024
set.clear.capacity    # => 4
```

## Requirements

Ruby 4+ (CRuby)
