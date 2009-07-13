# Test that Sprout can plot points on bitmaps, e.g. the screen.
# Expected result is 4 points drawn as a rectangle in a 400x300 window for 2
# seconds.

require 'sprout'

puts <<TEST
4 coloured points should appear in a rectangle formation, in a 400x300 window
for 2 seconds.  Point formation:

    red --- green
    |           |
    blue -- white
TEST

Sprout.init
Sprout.screen_mode 400, 300

Sprout.screen.draw Sprout::Point, 100,  75, 0xff0000ff
Sprout.screen.draw Sprout::Point, 300,  75, 0x00ff00ff
Sprout.screen.draw Sprout::Point, 100, 225, 0x0000ffff
Sprout.screen.draw Sprout::Point, 300, 225, 0xffffffff

Sprout.screen.flip

sleep 2
