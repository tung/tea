# This file contains the Screen class.

require 'sdl'

require 'c_bitmap'

#
module Sprout

  # Set the video mode for the screen in pixels.
  #
  # May raise Sprout::Error if it fails.
  def Sprout.screen_mode(width, height)
    @screen = ScreenInternal.new(width, height)
  end

  # Sprout.screen is the right way to get the screen bitmap.
  def Sprout.screen
    @screen
  end

  # The internal screen class implementation.  Should only be made once,
  # through Sprout.screen_mode.
  class ScreenInternal < Bitmap
    BITS_PER_PIXEL = 32

    # Used internally by Sprout to set the video mode.  Use Sprout.screen_mode
    # instead.
    def initialize(width, height)
      begin
        @buffer = SDL::Screen.open(width, height, BITS_PER_PIXEL, SDL::SWSURFACE)
      rescue SDL::Error => e
        raise Sprout::Error, e.message, e.backtrace
      end
    end

    # Flip the back buffer and display buffer so things drawn to the screen can
    # be seen.
    def flip
      @buffer.flip
    end

  end

end
