# Test circle drawing.
# Expected results are a large white circle behind 2 smaller green and red
# circles, in a 400x300 window for 3 seconds.

require 'tea'

puts <<TEST
You should see a 400x300 window for 3 seconds with:

 * A large white circle
 * A small green circle on the left, antialiased
 * A small red circle on the right, outlined
TEST

Tea.init
Tea::Screen.set_mode 400, 300

Tea::Screen.circle 200, 150, 100, Tea::Color::WHITE
Tea::Screen.circle 100, 150,  50, Tea::Color::GREEN, :antialias => true
Tea::Screen.circle 300, 150,  50, Tea::Color::RED, :outline => true

Tea::Screen.update

sleep 3
