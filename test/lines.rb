# Test that lines of various colours can be drawn.
# Expected results are a 400x300 for 5 seconds with:
#
# * 3 vertical lines on the left:         red, green, blue
# * 3 horizontal lines at the top-right:  yellow, magenta, cyan
# * 2 diagonal lines at the bottom-right: white and grey
#
# The white line should be antialiased.

require 'sprout'

puts <<TEST
You should see a 400x300 window for 5 seconds with:

 * 3 vertical lines on the left:         red, green, blue
 * 3 horizontal lines at the top-right:  yellow, magenta, cyan
 * 2 diagonal lines at the bottom-right: white and grey

The white line should be antialiased.
TEST

Sprout.init
Sprout.screen_mode 400, 300

grid_x = Sprout.screen.w / 10
grid_y = Sprout.screen.h / 10

lines = [[1,   1,   1,   9, 0xff0000ff, false],
         [2,   1,   2,   9, 0x00ff00ff, false],
         [3,   1,   3,   9, 0x0000ffff, false],
         [6,   1,   9,   1, 0xffff00ff, false],
         [6,   2,   9,   2, 0xff00ffff, false],
         [6,   3,   9,   3, 0x00ffffff, false],
         [6,   6,   9,   9, 0xffffffff, true ],
         [6,   9,   9,   6, 0x808080ff, false]]

lines.each do |line|
  Sprout.screen.draw Sprout::Line,
                     grid_x * line[0], grid_y * line[1],
                     grid_x * line[2], grid_y * line[3],
                     line[4],
                     :antialias => line[5]
end

Sprout.screen.flip

sleep 5
