# This file holds the classes and methods needed to draw primitives on Bitmaps.

require 'sdl'

#
module Tea

  private

  # The PrimitiveDrawing mixin enables primitive shapes to be drawn to classes
  # with an internal SDL::Surface.
  #
  # To use this mixin, include it and implement/alias a +primitive_buffer+
  # method that gets the object's SDL::Surface.
  #
  #   include 'PrimitiveDrawing'
  #   def primitive_buffer
  #     @internal_sdl_buffer
  #   end
  module PrimitiveDrawing

    # Clear the drawing buffer.  This is the same as drawing a completely black
    # rectangle over the whole buffer.
    def clear
      primitive_buffer.fill_rect 0, 0, primitive_buffer.w, primitive_buffer.h,
                                 primitive_color(0x000000ff)
    end

    # Plot a point at (x, y) with the given color (0xRRGGBBAA) on the Bitmap.
    def point(x, y, color)
      primitive_buffer[x, y] = primitive_color(color)
    end

    # Draw a rectangle of size w * h with the top-left corner at (x, y) with
    # the given color (0xRRGGBBAA).
    def rect(x, y, w, h, color)
      primitive_buffer.fill_rect x, y, w, h, primitive_color(color)
    end

    # Draw a line from (x1, y1) to (x2, y2) with the given color (0xRRGGBBAA).
    # Optional hash arguments:
    #
    # +:antialias+::    If true, smooth the line with antialiasing.
    def line(x1, y1, x2, y2, color, options=nil)
      primitive_buffer.draw_line x1, y1, x2, y2,
                                 primitive_color(color),
                                 (options[:antialias] if options)
    end

    # Draw a circle centred at (x, y) with the given radius and color.
    # Optional hash arguments:
    #
    # +:outline+::    If true, do not fill the circle, just draw an outline.
    # +:antialias+::  If true, smooth the edges of the circle with
    #                 antialiasing.
    def circle(x, y, radius, color, options=nil)
      if options
        primitive_buffer.draw_circle x, y, radius, primitive_color(color),
                                     !options[:outline], options[:antialias]
      else
        primitive_buffer.draw_circle x, y, radius, primitive_color(color), true
      end
    end

    private

    # Convert hex_color of the form 0xRRGGBBAA to a color value the
    # primitive_buffer understands.
    def primitive_color(hex_color)
      red   = (hex_color & 0xff000000) >> 24
      green = (hex_color & 0x00ff0000) >> 16
      blue  = (hex_color & 0x0000ff00) >>  8
      alpha = (hex_color & 0x000000ff)
      primitive_buffer.map_rgba(red, green, blue, alpha)
    end

  end

end
