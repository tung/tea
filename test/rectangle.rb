# Test that filled rectangles can be drawn.
# Expected results are a 400x300 window, with a filled yellow rectangle in it.

require 'spot'

puts <<TEST
A 400x300 window should appear with a yellow rectangle for 2 seconds.
TEST

Spot.init
Spot::Screen.set_mode 400, 300
Spot::Screen.rectangle 50, 50, 300, 200, 0xffff00ff
Spot::Screen.flip

sleep 2
