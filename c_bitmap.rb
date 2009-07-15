# This file holds the Bitmap class, which are grids of pixels that hold
# graphics.

require 'sdl'

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

    private

    # The pixel buffer, currently an SDL::Surface.  Internal, don't touch this!
    attr_reader :buffer

    # Convert a color of the form 0xRRGGBBAA into a color value the Bitmap's
    # internal buffer understands.
    #
    # Internal, don't use this!
    def format_color(hex_color)
      red   = (hex_color & 0xff000000) >> 24
      green = (hex_color & 0x00ff0000) >> 16
      blue  = (hex_color & 0x0000ff00) >>  8
      alpha = (hex_color & 0x000000ff)
      @buffer.map_rgba(red, green, blue, alpha)
    end

  end

end
