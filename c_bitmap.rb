# This file holds the Bitmap class, which are grids of pixels that hold
# graphics.

require 'sdl'

require 'm_primitive_drawing'

#
module Spot

  # A Bitmap is a grid of pixels that holds graphics.
  class Bitmap

    # Create a new Bitmap from an image file.
    #
    # May raise Spot::Error if it fails.
    def initialize(image_path)
      begin
        @buffer = SDL::Surface.load(image_path)
      rescue SDL::Error => e
        raise Spot::Error, e.message, e.backtrace
      end
    end

    # Get the width of the Bitmap in pixels.
    def w
      @buffer.w
    end

    # Get the height of the Bitmap in pixels.
    def h
      @buffer.h
    end

    # Erase the contents of the Bitmap.  Same as drawing a black rectangle over
    # the whole Bitmap.
    def clear
      @buffer.fill_rect 0, 0, @buffer.w, @buffer.h, @buffer.map_rgba(0, 0, 0, 255)
    end

    # Draw the source_bitmap onto the current Bitmap at (x, y).
    #
    # 'blit' is short for bit block transfer, which is how one Bitmap is drawn
    # onto another.
    def blit(source_bitmap, x, y)
      src = source_bitmap.send(:buffer)
      SDL::Surface.blit src, 0, 0, src.w, src.h, @buffer, x, y
    end

    include Spot::PrimitiveDrawing
    def primitive_buffer
      @buffer
    end

    private

    # The pixel buffer, currently an SDL::Surface.  Internal, don't touch this!
    attr_reader :buffer

  end

end
