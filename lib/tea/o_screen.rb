# This file contains the Screen class.

require 'weakref'

require 'sdl'

require 'tea/c_bitmap'
require 'tea/mix_blitting'
require 'tea/mix_clipping'
require 'tea/mix_grabbing'
require 'tea/mix_image_saving'
require 'tea/mix_primitive'

#
module Tea

  # A Bitmap-like object that displays its contents on the screen when drawn to
  # and updated.
  class Screen

    # Video buffer depth.
    BITS_PER_PIXEL = 32

    # Set or change the screen video mode, giving a width * height screen buffer.
    def Screen.set_mode(width, height)
      @screen = SDL::Screen.open(width, height, BITS_PER_PIXEL, SDL::SWSURFACE)

      # Optimize Bitmaps that registered for it.
      (0...(@bitmaps_to_optimize.length)).to_a.reverse.each do |opt_index|
        begin
          @bitmaps_to_optimize[opt_index].optimize_for_screen
        rescue WeakRef::RefError
          @bitmaps_to_optimize.delete_at opt_index
        end
      end
    rescue SDL::Error => e
      raise Tea::Error, e.message, e.backtrace
    end

    # Check if Screen.set_mode has been called yet.
    def Screen.mode_set?
      @screen ? true : false
    end

    # Register a Bitmap object to be optimised to the Screen's format when a
    # screen mode is set.
    def Screen.register_bitmap_for_optimizing(bitmap)
      @bitmaps_to_optimize << WeakRef.new(bitmap)
    end
    @bitmaps_to_optimize = []

    # Get the screen width in pixels.
    def Screen.w
      @screen.w
    end

    # Get the screen height in pixels.
    def Screen.h
      @screen.h
    end

    # Update the screen so that things drawn on it are displayed.
    def Screen.update
      @screen.flip
    end

    extend Blitting
    def Screen.blitting_buffer
      @screen
    end

    extend Clipping
    def Screen.clipping_buffer
      @screen
    end

    extend Grabbing
    def Screen.grabbing_buffer
      @screen
    end

    extend ImageSaving
    def Screen.image_saving_buffer
      @screen
    end

    extend Primitive
    def Screen.primitive_buffer
      @screen
    end

  end

end
