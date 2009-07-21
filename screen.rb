# This file contains the Screen class.

require 'sdl'

require 'm_blitting'
require 'm_primitive_drawing'

#
module Tea

  Screen = Class.new do

    # Video buffer depth.
    BITS_PER_PIXEL = 32

    # Set or change the screen video mode, giving a width * height screen
    # buffer.
    def set_mode(width, height)
      begin
        @screen = SDL::Screen.open(width, height, BITS_PER_PIXEL, SDL::SWSURFACE)
      rescue SDL::Error => e
        raise Tea::Error, e.message, e.backtrace
      end
    end

    # Get the screen width in pixels.
    def w
      @screen.w
    end

    # Get the screen height in pixels.
    def h
      @screen.h
    end

    # Update the screen so that things drawn on it are displayed.
    def update
      @screen.flip
    end

    include Tea::Blitting
    def blittable_buffer
      @screen
    end

    include Tea::PrimitiveDrawing
    def primitive_buffer
      @screen
    end

  end.new

end
