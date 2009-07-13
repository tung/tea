# This file contains the Screen class.

require 'c_bitmap'

#
module Sprout

  # Sprout.screen is the right way to get the screen bitmap.
  attr_reader :screen

  # Set the video mode for the screen in pixels.
  #
  # May raise Sprout::Error if it fails.
  def Sprout.screen_mode(width, height)
    @screen = ScreenInternal.new(width, height)
  end

  # The internal screen class implementation.  Should only be made once,
  # through Sprout.screen_mode.
  class ScreenInternal < Bitmap
    BITS_PER_PIXEL = 32

    def initialize(width, height)
      begin
        @buffer = SDL::Screen.open(width, height, BITS_PER_PIXEL, SDL::SWSURFACE)
      rescue SDL::Error => e
        raise Sprout::Error, e.message, e.backtrace
      end
    end
  end

end
