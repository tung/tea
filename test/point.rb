# Test that Tea can plot points on bitmaps, e.g. the screen.
# Expected result is 4 points drawn as a rectangle in a 400x300 window for 2
# seconds.

require 'tea'

puts <<TEST
4 coloured points should appear in a rectangle formation, in a 400x300 window
for 2 seconds.  Point formation:

    red --- green
    |           |
    blue -- white
TEST

Tea.init
Tea::Screen.set_mode 400, 300

Tea::Screen.point 100,  75, 0xff0000ff
Tea::Screen.point 300,  75, 0x00ff00ff
Tea::Screen.point 100, 225, 0x0000ffff
Tea::Screen.point 300, 225, 0xffffffff

Tea::Screen.update

sleep 2
