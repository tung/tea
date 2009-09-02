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

lines = [[1,   1,   1,   9, Tea::Color::RED],
         [2,   1,   2,   9, Tea::Color::GREEN],
         [3,   1,   3,   9, Tea::Color::BLUE],
         [6,   1,   9,   1, Tea::Color::YELLOW],
         [6,   2,   9,   2, Tea::Color::MAGENTA],
         [6,   3,   9,   3, Tea::Color::CYAN],
         [6,   9,   9,   6, Tea::Color::DARK_GRAY]]

lines.each do |line|
  Tea::Screen.line grid_x * line[0], grid_y * line[1],
                    grid_x * line[2], grid_y * line[3],
                    line[4]
end

Tea::Screen.line grid_x * 6, grid_y * 6,
                  grid_x * 9, grid_y * 9,
                  Tea::Color::WHITE,
                  :antialias => true

Tea::Screen.update

sleep 5
