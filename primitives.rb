# This file holds the classes and methods needed to draw primitives on Bitmaps.

require 'sdl'

#
module Spot

  Point = Object.new
  def Point.draw_to(dest_bitmap, x, y, color)
    dest_bitmap.buffer_[x, y] = dest_bitmap.format_color_(color)
  end

  Rectangle = Object.new
  def Rectangle.draw_to(dest_bitmap, x, y, w, h, color)
    dest_bitmap.buffer_.fill_rect x, y, w, h, dest_bitmap.format_color_(color)
  end

  Line = Object.new
  def Line.draw_to(dest_bitmap, x1, y1, x2, y2, color, options=nil)
    dest_bitmap.buffer_.draw_line x1, y1, x2, y2,
                                  dest_bitmap.format_color_(color),
                                  (options[:antialias] if options)
  end

  Circle = Object.new
  def Circle.draw_to(dest_bitmap, x, y, radius, color, options=nil)
    buf = dest_bitmap.buffer_
    col = dest_bitmap.format_color_(color)
    if options
      buf.draw_circle x, y, radius, col, !options[:outline], options[:antialias]
    else
      buf.draw_circle x, y, radius, col, true
    end
  end

end
