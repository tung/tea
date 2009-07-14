# This file holds the classes and methods needed to draw primitives on Bitmaps.

#
module Sprout

  Point = Object.new
  def Point.draw_to(dest_bitmap, x, y, color)
    dest_bitmap.buffer_[x, y] = dest_bitmap.format_color_(color)
  end

end
