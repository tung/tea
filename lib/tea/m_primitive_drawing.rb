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
    #
    # Raises Tea::Error if (x, y) is outside of the drawing buffer.
    def point(x, y, color)
      w = primitive_buffer.w
      h = primitive_buffer.h
      if x < 0 || x > w || y < 0 || y > h
        raise Tea::Error, "can't plot point (#{x}, #{y}), not within #{w}x#{h}", caller
      end
      primitive_buffer[x, y] = primitive_color(color)
    end

    # Draw a rectangle of size w * h with the top-left corner at (x, y) with
    # the given color (0xRRGGBBAA).  Hash arguments that can be used:
    #
    # +:mix+::    +:blend+ averages the RGB parts the rectangle and destination
    #             colours according to the colour's alpha (default).
    #             +:replace+ writes over the full RGBA parts of the rectangle
    #             area's pixels.
    #
    # Raises Tea::Error if w or h are less than 0, or if +:mix+ is given an
    # unrecognised symbol.
    def rect(x, y, w, h, color, options=nil)
      if w < 0 || h < 0 || (options && options[:mix] == :blend && (w < 1 || h < 1))
        raise Tea::Error, "can't draw rectangle of size #{w}x#{h}", caller
      end

      if options == nil || options[:mix] == nil
        mix = :blend
      else
        unless [:blend, :replace].include?(options[:mix])
          raise Tea::Error, "invalid mix option \"#{options[:mix]}\"", caller
        end
        mix = options[:mix]
      end

      case mix
      when :blend
        r, g, b, a = primitive_hex_to_rgba(color)
        # draw_rect has an off-by-one error with the width and height, hence the "- 1"s.
        return if w < 1 || h < 1
        primitive_buffer.draw_rect x, y, w - 1, h - 1, primitive_rgba_to_color(r, g, b, 255), true, a
      when :replace
        primitive_buffer.fill_rect x, y, w, h, primitive_color(color)
      end
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

    # Draw a circle centred at (x, y) with the given radius and color
    # (0xRRGGBBAA).  Optional hash arguments:
    #
    # +:outline+::    If true, do not fill the circle, just draw an outline.
    # +:antialias+::  If true, smooth the edges of the circle with
    #                 antialiasing.
    #
    # Raises Tea::Error if the radius is less than 0.
    def circle(x, y, radius, color, options=nil)
      if radius < 0
        raise Tea::Error, "can't draw circle with radius #{radius}", caller
      end

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
      primitive_rgba_to_color(*primitive_hex_to_rgba(hex_color))
    end

    # Break hex_color from the form 0xRRGGBBAA to [red, green, blue, alpha].
    def primitive_hex_to_rgba(hex_color)
      red   = (hex_color & 0xff000000) >> 24
      green = (hex_color & 0x00ff0000) >> 16
      blue  = (hex_color & 0x0000ff00) >>  8
      alpha = (hex_color & 0x000000ff)
      [red, green, blue, alpha]
    end

    # Generate a colour compatible with the primitive buffer.
    def primitive_rgba_to_color(red, green, blue, alpha=255)
      primitive_buffer.map_rgba(red, green, blue, alpha)
    end

  end

end
