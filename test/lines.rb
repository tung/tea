# Test that lines of various colours can be drawn.
# Expected results are a 400x300 for 5 seconds with:
#
# * 3 vertical lines on the left:         red, green, blue
# * 3 horizontal lines at the top-right:  yellow, magenta, cyan
# * 2 diagonal lines at the bottom-right: white and grey
#
# The white line should be antialiased.

require 'tea'

puts <<TEST
You should see a 400x300 window for 5 seconds with:

 * 3 vertical lines on the left:         red, green, blue
 * 3 horizontal lines at the top-right:  yellow, magenta, cyan
 * 2 diagonal lines at the bottom-right: white and grey

The white line should be antialiased.
TEST

Tea.init
Tea::Screen.set_mode 400, 300

grid_x = Tea::Screen.w / 10
grid_y = Tea::Screen.h / 10

lines = [[1,   1,   1,   9, 0xff0000ff],
         [2,   1,   2,   9, 0x00ff00ff],
         [3,   1,   3,   9, 0x0000ffff],
         [6,   1,   9,   1, 0xffff00ff],
         [6,   2,   9,   2, 0xff00ffff],
         [6,   3,   9,   3, 0x00ffffff],
         [6,   9,   9,   6, 0x808080ff]]

lines.each do |line|
  Tea::Screen.line grid_x * line[0], grid_y * line[1],
                    grid_x * line[2], grid_y * line[3],
                    line[4]
end

Tea::Screen.line grid_x * 6, grid_y * 6,
                  grid_x * 9, grid_y * 9,
                  0xffffffff,
                  :antialias => true

Tea::Screen.flip

sleep 5
