# This file holds the Bitmap class, which are grids of pixels that hold
# graphics.

require 'sdl'

require 'm_blitting'
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

    include Spot::Blitting
    def blittable_buffer
      @buffer
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
