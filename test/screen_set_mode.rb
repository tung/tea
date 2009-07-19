# Test if the screen can initialise.
# Expected results:
#
#  * output of "screen size is 320x240"
#  * a blank 320x240 display window for 2 seconds.

require 'tea'

puts <<TEST
You should see a 320x240 window for 2 seconds, and the text "screen size is 320x240"
TEST

Tea.init
Tea::Screen.set_mode 320, 240

puts "screen size is #{Tea::Screen.w}x#{Tea::Screen.h}"

sleep 2
