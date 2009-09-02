# Test that filled rectangles can be drawn.
# Expected results are a 400x300 window, with a filled yellow rectangle in it.

require 'tea'

puts <<TEST
A 400x300 window should appear with a yellow rectangle for 2 seconds.
TEST

Tea.init
Tea::Screen.set_mode 400, 300
Tea::Screen.rect 50, 50, 300, 200, Tea::Color::YELLOW
Tea::Screen.update

sleep 2
