# This file contains the Blitting mixin.

require 'sdl'

#
module Tea

  # The Blitting mixin allows objects with SDL::Surface to draw or 'blit' onto
  # each other.
  #
  # To use this mixin, include it and write/alias a blittable_buffer method
  # that gets the SDL::Surface.
  #
  #   include Blitting
  #   def blittable_buffer
  #     @my_sdl_surface
  #   end
  module Blitting

    # Draw the source_blittable onto the current object at (x, y).
    #
    # source_blittable needs to include the Blitting mixin too.
    def blit(source_blittable, x, y)
      src = source_blittable.send(:blittable_buffer)
      dest = blittable_buffer
      SDL::Surface.blit src, 0, 0, src.w, src.h, dest, x, y
    end

  end

end
