# This file contains the Screen class.

require 'sdl'

require 'm_blitting'
require 'm_primitive_drawing'

#
module Tea

  # A Bitmap-like object that displays its contents on the screen when drawn to
  # and updated.
  class Screen

    # Video buffer depth.
    BITS_PER_PIXEL = 32

    # Set or change the screen video mode, giving a width * height screen buffer.
    def Screen.set_mode(width, height)
      begin
        @screen = SDL::Screen.open(width, height, BITS_PER_PIXEL, SDL::SWSURFACE)
      rescue SDL::Error => e
        raise Tea::Error, e.message, e.backtrace
      end
    end

    # Get the screen width in pixels.
    def Screen.w; @screen.w; end

    # Get the screen height in pixels.
    def Screen.h; @screen.h; end

    # Update the screen so that things drawn on it are displayed.
    def Screen.update; @screen.flip; end

    extend Blitting
    def Screen.blittable_buffer; @screen; end

    extend PrimitiveDrawing
    def Screen.primitive_buffer; @screen; end

  end

end
