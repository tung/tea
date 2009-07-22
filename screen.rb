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
        @set_mode_callbacks.pop.call while @set_mode_callbacks.length > 0
        @set_mode_callbacks_permanent.each { |c| c.call }
      rescue SDL::Error => e
        raise Tea::Error, e.message, e.backtrace
      end
    end

    # Check if Screen.set_mode has been called yet.
    def Screen.mode_set?
      @screen ? true : false
    end

    # Set a proc to be called when Screen.set_mode is called.  The proc will be
    # called after the new screen mode is set.  The callback ordering is not
    # defined, so don't make callbacks that depend on other callbacks being
    # called first.
    #
    # If +keep+ is false (default), the callback is discarded after it is called.
    def Screen.on_set_mode(callback, keep=false)
      if keep
        @set_mode_callbacks << callback
      else
        @set_mode_callbacks_permanent << callback
      end
    end
    @set_mode_callbacks = []
    @set_mode_callbacks_permanent = []

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
