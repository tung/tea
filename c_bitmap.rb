# This file holds the Bitmap class, which are grids of pixels that hold
# graphics.

require 'sdl'

#
module Sprout

  # A Bitmap is a grid of pixels that holds graphics.
  class Bitmap

    # Create a new Bitmap from an image file.
    #
    # May raise Sprout::Error if it fails.
    def initialize(image_path)
      begin
        @buffer = SDL::Surface.load(image_path)
      rescue SDL::Error => e
        raise Sprout::Error, e.message, e.backtrace
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

    # Draw the <var>drawable_object</var> on the Bitmap.  Equivalent to:
    #
    #   drawable_object.draw_to bitmap, *other_args
    def draw(drawable_object, *other_args)
      drawable_object.draw_to self, *other_args
    end

    # Draw the current Bitmap onto dest_bitmap at location (x, y).
    def draw_to(dest_bitmap, x, y)
      SDL::Surface.blit @buffer, 0, 0, @buffer.w, @buffer.h,
                        dest_bitmap.buffer_, x, y
    end

    # Get the internal pixel buffer of the Bitmap.  Currently it's an SDL
    # surface, but that could change at any time.
    #
    # This should only be called within a draw_to method to make an object
    # drawable onto a Bitmap.
    def buffer_
      @buffer
    end

    # Convert a colour of the form 0xRRGGBBAA to a form compatible with the
    # internal pixel buffer of the Bitmap.
    #
    # This is used internally by Sprout.  Anything that asks for a colour
    # should use a number of the form 0xRRGGBBAA, and Sprout will handle colour
    # formats automatically.
    def format_color_(color_in)
      red   = (color_in & 0xff000000) >> 24
      green = (color_in & 0x00ff0000) >> 16
      blue  = (color_in & 0x0000ff00) >>  8
      alpha = (color_in & 0x000000ff)
      @buffer.map_rgba(red, green, blue, alpha)
    end

  end

end
