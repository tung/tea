# This file holds the classes and methods needed to draw primitives on Bitmaps.

require 'sdl'

#
module Sprout

  Point = Object.new
  def Point.draw_to(dest_bitmap, x, y, color)
    dest_bitmap.buffer_[x, y] = dest_bitmap.format_color_(color)
  end

  Rectangle = Object.new
  def Rectangle.draw_to(dest_bitmap, x, y, w, h, color)
    dest_bitmap.buffer_.fill_rect x, y, w, h, dest_bitmap.format_color_(color)
  end

  Line = Object.new
  def Line.draw_to(dest_bitmap, x1, y1, x2, y2, color)
    dest_bitmap.buffer_.draw_line x1, y1, x2, y2, dest_bitmap.format_color_(color)
  end

end
