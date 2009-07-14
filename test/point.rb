# Test that Spot can plot points on bitmaps, e.g. the screen.
# Expected result is 4 points drawn as a rectangle in a 400x300 window for 2
# seconds.

require 'spot'

puts <<TEST
4 coloured points should appear in a rectangle formation, in a 400x300 window
for 2 seconds.  Point formation:

    red --- green
    |           |
    blue -- white
TEST

Spot.init
Spot.screen_mode 400, 300

Spot.screen.draw Spot::Point, 100,  75, 0xff0000ff
Spot.screen.draw Spot::Point, 300,  75, 0x00ff00ff
Spot.screen.draw Spot::Point, 100, 225, 0x0000ffff
Spot.screen.draw Spot::Point, 300, 225, 0xffffffff

Spot.screen.flip

sleep 2
