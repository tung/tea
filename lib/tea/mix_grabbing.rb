# This file contains the Grabbing mixin, which makes a new Bitmap object based
# on some part of a bitmap-like pixel buffer.

require 'sdl'

require 'tea/c_bitmap'

#
module Tea

  # This module gives bitmap-like objects a +grab+ method that takes a
  # 'snapshot' of some part of it and returns it as a new Bitmap.
  #
  # To use this mixin, include it and define a +grabbing_buffer+ method:
  #
  #   include Grabbing
  #   def grabbing_buffer
  #     @my_sdl_buffer
  #   end
  #
  module Grabbing

    # Grab some part of the bitmap-like object, and return it as a new
    # Tea::Bitmap object.
    #
    # This can be called in two ways:
    #
    # * ()::            create a deep-copy of the whole bitmap-like object.
    # * (x, y, w, h)::  copy the pixels within the box at (x, y) of size w * h.
    #
    # May raise Tea::Error if the box given (if any) is outside the bitmap.
    def grab(*box)
      buffer = grabbing_buffer

      case box.length
      when 0
        x = 0
        y = 0
        w = buffer.w
        h = buffer.h
      when 4
        if clipped_box = grabbing_clip(*box, 0, 0, buffer.w, buffer.h)
          x, y, w, h = clipped_box
        else
          raise Tea::Error, "cannot grab (#{x}, #{y}, #{w}, #{h}), not within (#{buffer.x}, #{buffer.y}, #{buffer.w}, #{buffer.h})", caller
        end
      else
        raise ArgumentError, "wrong number of arguments (#{box.length} for 0 or 4)", caller
      end

      bitmap = Bitmap.new(w, h, 0x00000000)

      for buf_y in y..(y + h)
        for buf_x in x..(x + w)
          red, green, blue, alpha = buffer.get_rgba(buffer[buf_x, buf_y])
          bitmap.point buf_x - x, buf_y - y, ((red << 24) | (green << 16) | (blue << 8) | alpha)
        end
      end

      bitmap
    end

    # Keep the rect (x, y, w, h) within the rect (bound_x, bound_y, bound_w, bound_h).
    #
    # Returns [in_x, in_y, in_w, in_h], defining a rect like (x, y, w, h), but
    # within the bounding rect.  Returns nil if the rect given is not within
    # the bounding rect at all, i.e. w or h would be less than 1.
    def grabbing_clip(x, y, w, h, bound_x, bound_y, bound_w, bound_h)
      return nil if x + w <= bound_x || x >= bound_x + bound_w || y + h <= bound_y || y >= bound_y + bound_h

      in_x = (x >= bound_x) ? x : bound_x
      in_y = (y >= bound_y) ? y : bound_y

      x2 = x + w
      y2 = y + h
      in_x2 = (x2 <= bound_x + bound_w) ? x2 : bound_x + bound_w
      in_y2 = (y2 <= bound_y + bound_h) ? y2 : bound_y + bound_h
      in_w = in_x2 - in_x
      in_h = in_y2 - in_y

      [in_x, in_y, in_w, in_h]
    end

  end

end
