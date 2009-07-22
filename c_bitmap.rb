# This file holds the Bitmap class, which are grids of pixels that hold
# graphics.

require 'sdl'

require 'm_blitting'
require 'm_primitive_drawing'

#
module Tea

  # A Bitmap is a grid of pixels that holds graphics.
  class Bitmap

    # Create a new Bitmap from an image file.
    #
    # May raise Tea::Error if it fails.
    def initialize(image_path)
      begin
        @buffer = SDL::Surface.load(image_path)

        # Optimise for the screen mode, potentially making screen blits faster.
        if Tea::Screen.mode_set?
          @buffer = @buffer.display_format_alpha
        else
          Tea::Screen.on_set_mode lambda { @buffer = @buffer.display_format_alpha }
        end
      rescue SDL::Error => e
        raise Tea::Error, e.message, e.backtrace
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

    include Tea::Blitting
    def blittable_buffer
      @buffer
    end

    include Tea::PrimitiveDrawing
    def primitive_buffer
      @buffer
    end

  end

end
