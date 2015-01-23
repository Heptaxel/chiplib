#
# Copyright (c) 2015, Siddharth Heroor
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the
# distribution.
#
# Neither the name of the Siddharth Heroor nor the names of its
# contributors may be used to endorse or promote products derived
# from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
#

class Chip
  attr_reader :name, :hwblocks, :memory_map

  def initialize(name, &block)
    @name = name
    @hwblocks = Array.new
    @memory_map = Hash.new
    instance_eval(&block)
  end

  def hwblock(name, baseaddress, &block)
    h = HWBlock.new(name, &block)
    memory_map[name] = baseaddress
    @hwblocks << h
  end

  def clone_hwblock(name, new_name, baseaddress)
    h = @hwblocks.find{|h| h.name == name}.clone
    h.name = new_name
    memory_map[new_name] = baseaddress
    @hwblocks << h
  end

  def get_binding
    return binding()
  end

end

class HWBlock
  attr_reader :name, :description, :registers

  def initialize(name, &block)
    @name = name
    @registers = Array.new

    instance_eval(&block)
  end

  def register(name, &block)
    r = Register.new(name, &block)
    @registers << r
  end

  def has_description(d)
    @description = d
  end

  def get_binding()
    return binding()
  end
end

class Register
  attr_reader :name, :description, :size, :offset, :group, :reset, :access, :fields

  # Different Register Sizes
  REGISTER_SIZES = [8, 16, 32, 64]

  # Supported Types
  ACCESS_TYPES = ["rw", "ro", "wo"]
  
  def initialize(name, &block)
    @name   = name
    @size   = 32
    @offset = 0x0
    @reset  = 0x0
    @type   = "rw"
    @fields = Array.new
    @group  = nil

    instance_eval(&block)
  end

  def has_description(d)
    @description = d 
  end

  def has_offset (o)
    @offset = o
  end

  def in_group(range, step)
    @group = Hash.new
    @group["range"] = range
    @group["step"]  = step
  end
  
  def has_reset(value)
    @reset = value
  end

  def has_access(type)
    @access = type
  end

  def field(name, size, pos, &block)
    f = Field.new(name, size, pos)
    f.instance_eval(&block)

    @fields << f
  end

  def get_binding
    return binding()
  end
end

class Field
  attr_reader :name, :description, :size, :pos, :mask, :enum, :access

  # Lookup table to get the bit mask for number 
  # of bits
  BIT_MASKS = [0x0, 0x1, 0x3, 0x7, 0xF, 0x1F, 0x3F, 0x7F,
               0xFF, 0x1FF, 0x3FF, 0x7FF, 0xFFF, 0x1FFF,
               0x3FFF, 0x7FFF, 0xFFFF, 0x1FFFF, 0x3FFFF,
               0x7FFFF, 0xFFFFF, 0x1FFFFF, 0x3FFFFF,
               0x7FFFFF, 0xFFFFFF, 0x1FFFFFF, 0x3FFFFFF, 
               0x7FFFFFF, 0xFFFFFFF, 0x1FFFFFFF, 0x3FFFFFFF, 
               0x7FFFFFFF, 0xFFFFFFFF]

  # Supported Types
  ACCESS_TYPES = ["rw", "ro", "wo"]
  
  def initialize(name, size, pos)
    @name = name
    @size = size
    @pos  = pos
    @mask = BIT_MASKS[size] << pos
    @enum = Hash.new
    @access = "rw"
  end

  def has_enum(name, value)
    enum[name] = value
  end

  def has_access(type)
    @access = type
  end

  def get_binding
    return binding()
  end
end
