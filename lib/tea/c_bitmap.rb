# This file holds the Bitmap class, which are grids of pixels that hold
# graphics.

require 'sdl'

require 'tea/mix_blitting'
require 'tea/mix_clipping'
require 'tea/mix_grabbing'
require 'tea/mix_image_saving'
require 'tea/mix_primitive'

#
module Tea

  # A Bitmap is a grid of pixels that holds graphics.
  class Bitmap

    # Create a new Bitmap.  This can be done in 2 ways:
    #
    # (image_path)::            loads from an image
    # (width, height, color)::  creates with the given size and color
    #
    # May raise ArgumentError if the arguments passed in don't match one of the
    # above, or Tea::Error if the Bitmap creation fails.
    def initialize(*args)
      case args.length
      when 1 then from_image(*args)
      when 3 then fresh(*args)
      else
        raise ArgumentError, "wrong number of arguments (#{args.length} for 1 or 3)", caller
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

    # Convert the Bitmap's internal format to that of the screen to speed up
    # drawing.  Intended for internal use, but calling it manually won't bring
    # any harm.
    def optimize_for_screen
      @buffer = @buffer.display_format_alpha
    end

    include Blitting
    def blitting_buffer
      @buffer
    end

    include Clipping
    def clipping_buffer
      @buffer
    end

    include Grabbing
    def grabbing_buffer
      @buffer
    end

    include ImageSaving
    def image_saving_buffer
      @buffer
    end

    include Primitive
    def primitive_buffer
      @buffer
    end

    private

    # Create a new Bitmap from an image file.
    #
    # May raise Tea::Error if it fails.
    def from_image(image_path)
      @buffer = SDL::Surface.load(image_path)

      if Tea::Screen.mode_set?
        optimize_for_screen
      else
        Tea::Screen.register_bitmap_for_optimizing self
      end
    rescue SDL::Error => e
      raise Tea::Error, e.message, e.backtrace
    end

    # Create a new Bitmap of the given size and initialized with the color.
    #
    # May raise Tea::Error if it fails.
    def fresh(width, height, color)
      if width < 1 || height < 1
        raise Tea::Error, "can't create bitmap smaller than 1x1 (#{width}x#{height})", caller
      end

      # Default to big endian, as it works better with SGE's anti-aliasing.
      rmask = 0xff000000
      gmask = 0x00ff0000
      bmask = 0x0000ff00
      amask = 0x000000ff
      @buffer = SDL::Surface.new(SDL::SWSURFACE,
                                 width, height, 32,
                                 rmask, gmask, bmask, amask)
      rect 0, 0, w, h, color, :mix => :replace

      if Tea::Screen.mode_set?
        optimize_for_screen
      else
        Tea::Screen.register_bitmap_for_optimizing self
      end
    rescue SDL::Error => e
      raise Tea::Error, e.message, e.backtrace
    end

  end

end
