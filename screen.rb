# This file contains the Screen class.

require 'sdl'

require 'm_blitting'
require 'm_primitive_drawing'

#
module Spot

  Screen = Class.new do

    # Video buffer depth.
    BITS_PER_PIXEL = 32

    # Set or change the screen video mode, giving a width * height screen
    # buffer.
    def set_mode(width, height)
      begin
        @screen = SDL::Screen.open(width, height, BITS_PER_PIXEL, SDL::SWSURFACE)
      rescue SDL::Error => e
        raise Spot::Error, e.message, e.backtrace
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

    # Flip the back buffer and display buffer so that things drawn to the
    # screen can be seen.
    def flip
      @screen.flip
    end

    include Spot::Blitting
    def blittable_buffer
      @screen
    end

    include Spot::PrimitiveDrawing
    def primitive_buffer
      @screen
    end

  end.new

end