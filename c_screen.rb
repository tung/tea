# This file contains the Screen class.

require 'sdl'

require 'c_bitmap'

#
module Spot

  # Set the video mode for the screen in pixels.
  #
  # May raise Spot::Error if it fails.
  def Spot.screen_mode(width, height)
    @screen = Screen_.new(width, height)
  end

  # Spot.screen is the right way to get the screen bitmap.
  def Spot.screen
    @screen
  end

  # The internal screen class implementation.  Should only be made once,
  # through Spot.screen_mode.
  class Screen_ < Bitmap
    BITS_PER_PIXEL = 32

    # Used internally by Spot to set the video mode.  Use Spot.screen_mode
    # instead.
    def initialize(width, height)
      begin
        @buffer = SDL::Screen.open(width, height, BITS_PER_PIXEL, SDL::SWSURFACE)
      rescue SDL::Error => e
        raise Spot::Error, e.message, e.backtrace
      end
    end

    # Flip the back buffer and display buffer so things drawn to the screen can
    # be seen.
    def flip
      @buffer.flip
    end

  end

end
