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

    # Mixer for alpha blend mix strategy.
    BLEND_MIXER = lambda do |src_r, src_g, src_b, src_a, dest_r, dest_g, dest_b, dest_a, intensity|
      ai = src_a * intensity
      ratio = dest_a > 0 ? ai / dest_a.to_f : 1
      ratio = 1 if ratio > 1
      final_r = dest_r + (src_r - dest_r) * ratio
      final_g = dest_g + (src_g - dest_g) * ratio
      final_b = dest_b + (src_b - dest_b) * ratio
      final_a = (dest_a + ai < 255) ? (dest_a + ai) : 255
      [final_r, final_g, final_b, final_a]
    end

    # Mixer for replace mix strategy.
    REPLACE_MIXER = lambda do |src_r, src_g, src_b, src_a, dest_r, dest_g, dest_b, dest_a, intensity|
      [src_r, src_g, src_b, src_a * intensity]
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

      r, g, b, a = primitive_hex_to_rgba(color)
      case mix
      when :blend
        if a == 0xff
          # Same as for mix == :replace
          primitive_buffer.fill_rect x, y, w, h, primitive_rgba_to_color(r, g, b, a)
        elsif primitive_buffer.class == SDL::Screen
          # SGE's broken alpha blending doesn't matter on the screen, so
          # optimise for it.  rubysdl's draw_rect is off-by-one for width and
          # height, so compensate for that.
          primitive_buffer.draw_rect x, y, w - 1, h - 1, primitive_rgba_to_color(r, g, b, 255), true, a
        else
          # CAUTION: This is _really_ slow, almost unusably so.  Perhaps I
          # should consider not making :blend the default mix mode.
          primitive_rect x, y, w, h, r, g, b, a, BLEND_MIXER
        end
      when :replace
        primitive_buffer.fill_rect x, y, w, h, primitive_rgba_to_color(r, g, b, a)
      end
    end

    # Draw a line from (x1, y1) to (x2, y2) with the given color (0xRRGGBBAA).
    # Optional hash arguments:
    #
    # +:antialias+::    If true, smooth the line with antialiasing.
    # +:mix+::          +:blend+ averages the RGB parts of the line and
    #                   destination colours by the line alpha (default).
    #                   +:replace+ writes over the RGBA parts of the line
    #                   destination pixels.
    def line(x1, y1, x2, y2, color, options=nil)
      if options == nil
        antialias = false
        mix = :blend
      else
        antialias = options[:antialias] || false
        mix = options[:mix] || :blend

        unless [:blend, :replace].include?(mix)
          raise Tea::Error, "invalid mix option \"#{mix}\"", caller
        end
      end

      r, g, b, a = primitive_hex_to_rgba(color)
      if primitive_buffer.class == SDL::Screen
        primitive_buffer.draw_line x1, y1, x2, y2, primitive_rgba_to_color(r, g, b, (mix == :replace ? a : 255)), antialias, (mix == :blend ? a : nil)
      else
        if antialias
          primitive_aa_line x1, y1, x2, y2, r, g, b, a, (mix == :blend ? BLEND_MIXER : REPLACE_MIXER)
        else
          primitive_line x1, y1, x2, y2, r, g, b, a, (mix == :blend ? BLEND_MIXER : REPLACE_MIXER)
        end
      end
    end

    # Draw a circle centred at (x, y) with the given radius and color
    # (0xRRGGBBAA).  Optional hash arguments:
    #
    # +:outline+::    If true, do not fill the circle, just draw an outline.
    # +:antialias+::  If true, smooth the edges of the circle with
    #                 antialiasing.
    # +:mix+::        +:blend+ averages the RGB parts of the circle and
    #                 destination colours by the colour's alpha (default).
    #                 +:replace+ writes over the RGBA parts of the circle's
    #                 destination pixels.
    #
    # Raises Tea::Error if the radius is less than 0, or :mix is given an
    # unrecognised symbol.
    def circle(x, y, radius, color, options=nil)
      if radius < 0
        raise Tea::Error, "can't draw circle with radius #{radius}", caller
      end

      if options == nil
        outline = false
        antialias = false
        mix = :blend
      else
        outline = options[:outline] || false
        antialias = options[:antialias] || false
        mix = options[:mix] || :blend

        unless [:blend, :replace].include?(mix)
          raise Tea::Error, "invalid mix option \"#{mix}\"", caller
        end
      end

      if primitive_buffer.class == SDL::Screen
        case mix
        when :blend
          r, g, b, a = primitive_hex_to_rgba(color)
          if !outline && antialias && a < 0xff
            # rubysdl can't draw filled antialiased alpha circles for some reason.
            # Big endian because the SGE-powered circle antialiasing apparently
            # doesn't like it any other way.
            ts = SDL::Surface.new(SDL::SWSURFACE, (radius + 1) * 2, (radius + 1) * 2, 32,
                                  0xff000000,
                                  0x00ff0000,
                                  0x0000ff00,
                                  0x000000ff)
            ts.draw_circle radius + 1, radius + 1, radius, ts.map_rgba(r, g, b, a), true, true
            SDL::Surface.blit ts, 0, 0, ts.w, ts.h, primitive_buffer, x - radius - 1, y - radius - 1
          else
            primitive_buffer.draw_circle x, y, radius, primitive_rgba_to_color(r, g, b, 255),
                                         !outline, antialias, (a == 255 ? nil : a)
          end
        when :replace
          primitive_buffer.draw_circle x, y, radius, primitive_color(color), !outline, antialias
        end
      else
        # SGE and alpha mixing don't... mix.  Gotta do it ourselves.
        mixer = (mix == :blend) ? BLEND_MIXER : REPLACE_MIXER
        r, g, b, a = primitive_hex_to_rgba(color)
        primitive_circle x, y, radius, !outline, antialias, r, g, b, a, mixer
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

    # Fractional part of x, for primitive_aa_line.
    def primitive_fpart(x)
      x - x.truncate
    end

    # Inverse fractional part of x, for primitive_aa_line.
    def primitive_rfpart(x)
      1 - primitive_fpart(x)
    end

    # Run a block with the primitive buffer locked.
    def primitive_buffer_with_lock
      buffer = primitive_buffer
      if SDL::Surface.auto_lock?
        auto_lock = true
        SDL::Surface.auto_lock_off
      end
      buffer.lock if buffer.must_lock?
      begin
        yield
      ensure
        buffer.unlock if buffer.must_lock?
        SDL::Surface.auto_lock_on if auto_lock
      end
    end

    # Draw a line from (x1, y1) to (x2, y2) of color (red, green, blue).  The
    # +alpha+ is passed to the +mixer+ proc to determine how the line and
    # bitmap colours should be mixed.
    #
    # mixer = { |src_red, src_green, src_blue, src_alpha, dest_red, dest_green, dest_blue, dest_alpha, intensity| ... }
    def primitive_line(x1, y1, x2, y2, red, green, blue, alpha, mixer)

      buffer = primitive_buffer
      dx = x2 - x1
      dy = y2 - y1

      plot = Proc.new do |x, y, i|
        buf_r, buf_g, buf_b, buf_a = buffer.get_rgba(buffer[x, y])
        buffer[x, y] = buffer.map_rgba(*mixer.call(red, green, blue, alpha, buf_r, buf_g, buf_b, buf_a, i))
      end

      case
      when dx == 0 && dy == 0       # point
        plot.call x1, y1, 1.0
      when dx == 0 && dy != 0       # vertical line
        primitive_buffer_with_lock do
          for y in (y1.to_i)..(y2.to_i)
            plot.call x1, y, 1.0
          end
        end
      when dx != 0 && dy == 0       # horizontal line
        primitive_buffer_with_lock do
          for x in (x1.to_i)..(x2.to_i)
            plot.call x, y1, 1.0
          end
        end
      else  # Use Bresenham's line algorithm, from John Hall's Programming Linux Games.

        # Figure out the x and y spans of the line.
        xspan = dx + 1
        yspan = dy + 1

        # Figure out the correct increment for the major axis.
        # Account for negative spans (x2 < x1, for instance).
        if xspan < 0
          xinc = -1
          xspan = -xspan
        else
          xinc = 1
        end
        if yspan < 0
          yinc = -1
          yspan = -yspan
        else
          yinc = 1
        end

        x = x1
        y = y1
        error = 0

        primitive_buffer_with_lock do
          if xspan < yspan    # Draw a mostly vertical line.
            for step in 0..yspan
              plot.call x, y, 1.0
              error += xspan
              if error >= yspan
                x += xinc
                error -= yspan
              end
              y += yinc
            end
          else    # Draw a mostly horizontal line.
            for step in 0..xspan
              plot.call x, y, 1.0
              error += yspan
              if error >= xspan
                y += yinc
                error -= xspan
              end
              x += xinc
            end
          end
        end

      end
    end

    # Draw an antialiased line from (x1, y1) to (x2, y2) of colour (red, green,
    # blue).  The +alpha+ is passed to the +mixer+ proc to determine how the
    # line and bitmap colours should be mixed.
    #
    # mixer = { |src_red, src_green, src_blue, src_alpha, dest_red, dest_green, dest_blue, dest_alpha, intensity| ... }
    def primitive_aa_line(x1, y1, x2, y2, red, green, blue, alpha, mixer)

      buffer = primitive_buffer
      dx = x2 - x1
      dy = y2 - y1

      plot = Proc.new do |x, y, i|
        buf_r, buf_g, buf_b, buf_a = buffer.get_rgba(buffer[x, y])
        buffer[x, y] = buffer.map_rgba(*mixer.call(red, green, blue, alpha, buf_r, buf_g, buf_b, buf_a, i))
      end

      case
      when dx == 0 && dy == 0       # point
        plot.call x1, y1, 1.0
      when dx == 0 && dy != 0       # vertical line
        primitive_buffer_with_lock do
          for y in (y1.to_i)..(y2.to_i)
            plot.call x1, y, 1.0
          end
        end
      when dx != 0 && dy == 0       # horizontal line
        primitive_buffer_with_lock do
          for x in (x1.to_i)..(x2.to_i)
            plot.call x, y1, 1.0
          end
        end
      else  # Use Xiaolin Wu's line algorithm, described on Wikipedia.

        if dx.abs > dy.abs  # Draw a mostly horizontal line.
          if x2 < x1
            x1, x2 = x2, x1
            y1, y2 = y2, y1
          end
          gradient = dy.to_f / dx

          # Handle first endpoint.
          xend = x1.round
          yend = y1 + gradient * (xend - x1)
          xgap = primitive_rfpart(x1 + 0.5)
          xpxl1 = xend                # This will be used in the main loop.
          ypxl1 = yend.truncate
          plot.call xpxl1, ypxl1, primitive_rfpart(yend) * xgap
          plot.call xpxl1, ypxl1 + 1, primitive_fpart(yend) * xgap
          intery = yend + gradient    # First y-intersection for the main loop.

          # Handle second endpoint.
          xend = x2.round
          yend = y2 + gradient * (xend - x2)
          xgap = primitive_fpart(x2 + 0.5)
          xpxl2 = xend                # This will be used in the main loop.
          ypxl2 = yend.truncate
          plot.call xpxl2, ypxl2, primitive_rfpart(yend) * xgap
          plot.call xpxl2, ypxl2 = 1, primitive_fpart(yend) * xgap

          primitive_buffer_with_lock do
            for x in (xpxl1 + 1)..(xpxl2 - 1)
              intery_int = intery.truncate
              plot.call x, intery_int, primitive_rfpart(intery)
              plot.call x, intery_int + 1, primitive_fpart(intery)
              intery += gradient
            end
          end
        else  # Draw a mostly vertical line.
          if y2 < y1
            y1, y2 = y2, y1
            x1, x2 = x2, x1
          end
          gradient = dx.to_f / dy

          # Handle first endpoint.
          yend = y1.round
          xend = x1 + gradient * (yend - y1)
          ygap = primitive_rfpart(y1 + 0.5)
          ypxl1 = yend                # This will be used in the main loop.
          xpxl1 = xend.truncate
          plot.call xpxl1, ypxl1, primitive_rfpart(xend) * ygap
          plot.call xpxl1 + 1, ypxl1, primitive_fpart(xend) * ygap
          interx = xend + gradient    # First x-intersection for the main loop.

          # Handle second endpoint.
          yend = y2.round
          xend = x2 + gradient * (yend - y2)
          ygap = primitive_fpart(y2 + 0.5)
          ypxl2 = yend                # This will be used in the main loop.
          xpxl2 = xend.truncate
          plot.call xpxl2, ypxl2, primitive_rfpart(xend) * ygap
          plot.call xpxl2 + 1, ypxl2, primitive_fpart(xend) * ygap

          primitive_buffer_with_lock do
            for y in (ypxl1 + 1)..(ypxl2 - 1)
              interx_int = interx.truncate
              plot.call interx_int, y, primitive_rfpart(interx)
              plot.call interx_int + 1, y, primitive_fpart(interx)
              interx += gradient
            end
          end
        end

      end
    end

    # Draw a rectangle of size (w, h) with the top-left corner at (x, y), with
    # the colour (red, green, blue) and mixed with +alpha+ and +mixer+.
    #
    # mixer = { |src_red, src_green, src_blue, src_alpha, dest_red, dest_green, dest_blue, dest_alpha, intensity| ... }
    def primitive_rect(x, y, w, h, red, green, blue, alpha, mixer)
      buffer = primitive_buffer

      # Keep x, y, w, h within the clipping rectangle.
      x2 = x + w
      y2 = y + h
      clip_x, clip_y, clip_w, clip_h = buffer.get_clip_rect
      clip_x = 0 unless clip_x
      clip_y = 0 unless clip_y
      clip_w = buffer.w unless clip_w
      clip_h = buffer.h unless clip_h
      clip_x2 = clip_x + clip_w
      clip_y2 = clip_y + clip_h
      x = clip_x if x < clip_x
      y = clip_y if y < clip_y
      x2 = clip_x2 if x2 > clip_x2
      y2 = clip_y2 if y2 > clip_y2
      w = x2 - x
      h = y2 - y
      return unless w > 0 && h > 0

      primitive_buffer_with_lock do
        for py in y...(y + h)
          for px in x...(x + w)
            buf_r, buf_g, buf_b, buf_a = buffer.get_rgba(buffer[px, py])
            buffer[px, py] = buffer.map_rgba(*mixer.call(red, green, blue, alpha, buf_r, buf_g, buf_b, buf_a, 1.0))
          end
        end
      end
    end

    # Draw a circle centred at (x, y) with the given radius.
    def primitive_circle(x, y, radius, filled, antialias, red, green, blue, alpha, mixer)
      buffer = primitive_buffer

      radius = radius.round
      return if radius < 1 ||
                x + radius < 0 || x - radius >= buffer.w ||
                y + radius < 0 || y - radius >= buffer.h

      # TODO: Special-case optimise for REPLACE_MIXER, which doesn't need
      #       source pixel info.
      plot = Proc.new do |px, py, i|
        buf_r, buf_g, buf_b, buf_a = buffer.get_rgba(buffer[px, py])
        buffer[px, py] = buffer.map_rgba(*mixer.call(red, green, blue, alpha, buf_r, buf_g, buf_b, buf_a, i))
      end

      # Xiaolin Wu's circle algorithm, with extra stuff.  Graphics Gems II, part IX, chapter 9.
      plot.call x + radius, y,          1.0
      plot.call x - radius, y,          1.0
      plot.call x,          y + radius, 1.0
      plot.call x,          y - radius, 1.0

      i = radius
      j = 0
      t = 0

      # Stop two steps short so we can join the octants ourselves.
      until i - 2 <= j
        j += 1
        d = Math.sqrt(radius * radius - j * j).ceil - Math.sqrt(radius * radius - j * j)
        unless d > t
          # Graphics Gems II gets this wrong by writing the reverse condition.
          i -= 1
        end

        # first octant
        plot.call x + i,     y + j,     1.0 - d
        plot.call x + i - 1, y + j,     d

        # second octant
        plot.call x + j,     y + i,     1.0 - d
        plot.call x + j,     y + i - 1, d

        # third octant
        plot.call x - j,     y + i,     1.0 - d
        plot.call x - j,     y + i - 1, d

        # fourth octant
        plot.call x - i,     y + j,     1.0 - d
        plot.call x - i + 1, y + j,     d

        # fifth octant
        plot.call x - i,     y - j,     1.0 - d
        plot.call x - i + 1, y - j,     d

        # sixth octant
        plot.call x - j,     y - i,     1.0 - d
        plot.call x - j,     y - i + 1, d

        # seventh octant
        plot.call x + j,     y - i,     1.0 - d
        plot.call x + j,     y - i + 1, d

        # eigth octant
        plot.call x + i,     y - j,     1.0 - d
        plot.call x + i - 1, y - j,     d

        t = d
      end

      # plot final octant meeting points relative to octants 1, 3, 5 & 7
      j += 1
      d = Math.sqrt(radius * radius - j * j).ceil - Math.sqrt(radius * radius - j * j)
      i -= 1 unless d > t
      plot.call x + i, y + j, 1.0 - d
      plot.call x - j, y + i, 1.0 - d
      plot.call x - i, y - j, 1.0 - d
      plot.call x + j, y - i, 1.0 - d

    end

  end

end
