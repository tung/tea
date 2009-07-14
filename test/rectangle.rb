# Test that filled rectangles can be drawn.
# Expected results are a 400x300 window, with a filled yellow rectangle in it.

require 'spot'

puts <<TEST
A 400x300 window should appear with a yellow rectangle for 2 seconds.
TEST

Spot.init
Spot.screen_mode 400, 300
Spot.screen.draw Spot::Rectangle, 50, 50, 300, 200, 0xffff00ff
Spot.screen.flip

sleep 2
