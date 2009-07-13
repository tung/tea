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

  end

end
