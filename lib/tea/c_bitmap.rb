# This file holds the Bitmap class, which are grids of pixels that hold
# graphics.

require 'sdl'

require 'tea/m_blitting'
require 'tea/m_primitive_drawing'

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

    include Tea::Blitting
    def blittable_buffer
      @buffer
    end

    include Tea::PrimitiveDrawing
    def primitive_buffer
      @buffer
    end

    private

    # Create a new Bitmap from an image file.
    #
    # May raise Tea::Error if it fails.
    def from_image(image_path)
      @buffer = SDL::Surface.load(image_path)

      # Optimise for the screen mode, potentially making screen blits faster.
      if Tea::Screen.mode_set?
        @buffer = @buffer.display_format_alpha
      else
        Tea::Screen.on_set_mode lambda { @buffer = @buffer.display_format_alpha }
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

      # Optimise for the screen mode, now or later.
      if Tea::Screen.mode_set?
        @buffer = @buffer.display_format_alpha
      else
        Tea::Screen.on_set_mode lambda { @buffer = @buffer.display_format_alpha }
      end
    rescue SDL::Error => e
      raise Tea::Error, e.message, e.backtrace
    end

  end

end
