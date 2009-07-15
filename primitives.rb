# This file holds the classes and methods needed to draw primitives on Bitmaps.

require 'sdl'

require 'c_bitmap'

#
module Spot

  class Bitmap

    # Plot a point at (x, y) with the given color (0xRRGGBBAA) on the Bitmap.
    def point(x, y, color)
      @buffer[x, y] = format_color(color)
    end

    # Draw a rectangle of size w * h with the top-left corner at (x, y) with
    # the given color (0xRRGGBBAA).
    def rectangle(x, y, w, h, color)
      @buffer.fill_rect x, y, w, h, format_color(color)
    end

    # Draw a line from (x1, y1) to (x2, y2) with the given color (0xRRGGBBAA).
    # Optional hash arguments:
    #
    # +:antialias+::    If true, smooth the line with antialiasing.
    def line(x1, y1, x2, y2, color, options=nil)
      @buffer.draw_line x1, y1, x2, y2,
                        format_color(color),
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
        @buffer.draw_circle x, y, radius, format_color(color), !options[:outline], options[:antialias]
      else
        @buffer.draw_circle x, y, radius, format_color(color), true
      end
    end
  end

end
