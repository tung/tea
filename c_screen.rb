# This file contains the Screen class.

require 'c_bitmap'

#
module Sprout

  # The Screen holds a special bitmap that represents the display.  Anything
  # drawn to the screen will be displayed to the player.
  class Screen

    # Set the video mode for the screen in pixels.
    #
    # May raise Sprout::Error if it fails.
    def Screen.set_mode(width, height)
      @screen = ScreenInternal.new(width, height)
    end

    private

    # The internal screen class implementation.  Should only be made once, by
    # the higher-level Sprout::Screen class.
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

end
