# This file holds the classes and methods needed to draw primitives on Bitmaps.

#
module Sprout

  Point = Class.new do
    def self.draw_to(dest_bitmap, x, y, color)
      dest_bitmap.buffer_internal[x, y] = dest_bitmap.format_color_internal(color)
    end
  end

end
