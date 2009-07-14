# Test circle drawing.
# Expected results are a large white circle behind 2 smaller green and red
# circles, in a 400x300 window for 3 seconds.

require 'sprout'

puts <<TEST
You should see a 400x300 window for 3 seconds with:

 * A large white circle
 * A small green circle on the left, antialiased
 * A small red circle on the right, outlined
TEST

Sprout.init
Sprout.screen_mode 400, 300

Sprout.screen.draw Sprout::Circle, 200, 150, 100, 0xffffffff
Sprout.screen.draw Sprout::Circle, 100, 150,  50, 0x00ff00ff, :antialias => true
Sprout.screen.draw Sprout::Circle, 300, 150,  50, 0xff0000ff, :outline => true

Sprout.screen.flip

sleep 3
