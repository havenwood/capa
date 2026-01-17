# frozen_string_literal: true

require_relative 'capa/version'
require 'fiddle'

module Capa
  class UnsupportedRubyError < StandardError
    def initialize(msg = 'Capa only supports CRuby') = super
  end

  raise UnsupportedRubyError unless Ruby::ENGINE == 'ruby'

  GC_SLOT_SIZE = Fiddle::Function.new(
    Fiddle::Handle::DEFAULT['rb_gc_obj_slot_size'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_SIZE_T
  )

  module Offsets
    module Array
      EMBED = 0x2000
      CAPA = 24
      HEADER = 16
    end

    module String
      HEAP = 0x2000
      CAPA = 32
      HEADER = 24
    end

    module Hash
      ST = 0x8000
      TABLE = 24
      AR_CAPA = 8
    end

    module Set
      POWER = 32
    end

    module WeakKeyMap
      TABLE = 32
    end
  end

  module_function

  def read_long(addr, offset = 0)
    Fiddle::Pointer.new(addr + offset)[0, Fiddle::SIZEOF_VOIDP].unpack1('Q')
  end

  def read_byte(addr, offset = 0)
    Fiddle::Pointer.new(addr + offset)[0, 1].unpack1('C')
  end

  refine Array do
    def capacity
      addr = Fiddle.dlwrap(self)
      flags = Capa.read_long(addr)
      embedded = flags.anybits?(Offsets::Array::EMBED)

      return Capa.read_long(addr, Offsets::Array::CAPA) unless embedded

      (Capa::GC_SLOT_SIZE.call(addr) - Offsets::Array::HEADER) / Fiddle::SIZEOF_VOIDP
    end
  end

  refine String do
    def capacity
      addr = Fiddle.dlwrap(self)
      flags = Capa.read_long(addr)
      embedded = flags.nobits?(Offsets::String::HEAP)

      return Capa.read_long(addr, Offsets::String::CAPA) unless embedded

      Capa::GC_SLOT_SIZE.call(addr) - Offsets::String::HEADER
    end
  end

  refine Hash do
    def capacity
      addr = Fiddle.dlwrap(self)
      flags = Capa.read_long(addr)
      ar_mode = flags.nobits?(Offsets::Hash::ST)

      return Offsets::Hash::AR_CAPA if ar_mode

      1 << (Capa.read_byte(addr + Offsets::Hash::TABLE) - 1)
    end
  end

  refine Set do
    def capacity
      addr = Fiddle.dlwrap(self)

      1 << Capa.read_byte(addr, Offsets::Set::POWER)
    end
  end

  refine ObjectSpace::WeakKeyMap do
    def capacity
      addr = Fiddle.dlwrap(self)
      table_ptr = Capa.read_long(addr, Offsets::WeakKeyMap::TABLE)

      1 << Capa.read_byte(table_ptr)
    end
  end
end
